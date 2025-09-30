# Generates a unified LLM-friendly profile snapshot & JSON-LD graph.
# Nothing rendered visibly; only source-level artifacts (comment + script tag).
# Configuration: controlled by internal constants & existing _data YAML.
# Add `llm_featured: true` in front matter of thoughts/tinkers you want prioritized.

require 'json'
require 'digest'

module Jekyll
  class LlmProfileGenerator < Generator
    safe true
    priority :low

    VERSION = 'v1'
    MAX_PROJECTS = 10
    MAX_THOUGHTS = 8

    def generate(site)
      person = build_person(site)
      projects = top_projects(site)
      thoughts = featured_thoughts(site)
      skills   = extract_skills(site)
      edu      = education(site)
      leadership = leadership_roles(site)

      graph_nodes = []
      graph_nodes << person
      graph_nodes.concat(projects)
      graph_nodes.concat(thoughts)
      graph_nodes << skills if skills
      graph_nodes.concat(edu) if edu
      graph_nodes.concat(leadership) if leadership

      jsonld = {
        "@context" => "https://schema.org",
        "@graph" => graph_nodes
      }

      snapshot_text = build_snapshot_text(site, person, projects, thoughts, skills, edu, leadership)

      site.data['llm_profile_jsonld'] = JSON.pretty_generate(jsonld)
      site.data['llm_profile_text'] = snapshot_text

      # Expose hash for change detection (first 2048 chars) 
      digest = Digest::SHA256.hexdigest(snapshot_text[0, 2048])
      site.data['llm_profile_hash'] = digest

      inject_into_home(site, jsonld_str: site.data['llm_profile_jsonld'], snapshot: snapshot_text, hash: digest)
    end

    private

    def build_person(site)
      {
        "@type" => "Person",
        "@id" => site.config['url'],
        "name" => site.config['author'] || site.config['title'],
        "url" => site.config['url'],
        "description" => short_bio(site),
        "image" => site.config['social_image'],
        "sameAs" => same_as(site),
        "knowsAbout" => derive_domains(site)
      }.compact
    end

    def short_bio(site)
      intro_data = site.data['introduction']
      if intro_data.is_a?(String)
        intro_data.strip
      elsif intro_data.is_a?(Hash) && intro_data['bio']
        intro_data['bio'].to_s.strip
      else
        # Fallback: compress first experience sentence
        exp = site.data['experience']&.first
        exp ? exp['description'].to_s.split(/\.[\s\n]/).first.to_s.strip : ''
      end
    end

    def same_as(site)
      handles = []
      %w(github_username X_username).each do |k|
        val = site.config[k]
        next unless val && !val.to_s.empty?
        case k
        when 'github_username'
          handles << "https://github.com/#{val}" if val
        when 'X_username'
          handles << "https://x.com/#{val}" if val
        end
      end
      handles
    end

    def derive_domains(site)
      # Very lightweight domain extraction from skills categories + project tags
      domains = []
      (site.data['skills'] || {}).each do |_, arr|
        next unless arr.is_a?(Array)
  # Split on '(' or '/' characters if present (escape '[' usage)
  arr.each { |x| domains << x.split(/[\(\/]/).first.strip if x }
      end
      (site.data['projects'] || []).each do |p|
        (p['tags'] || []).each { |t| domains << t }
      end
      domains.map(&:downcase).uniq.first(40)
    end

    def top_projects(site)
      list = (site.data['projects'] || []).first(MAX_PROJECTS)
      list.map do |p|
        {
          "@type" => "CreativeWork",
          "@id" => [site.config['url'], 'project', slugify(p['title'])].join('#'),
          "name" => p['title'],
          "description" => p['description'],
          "keywords" => p['tags']
        }.compact
      end
    end

    def featured_thoughts(site)
      coll = site.collections['thoughts']
      return [] unless coll
      docs = coll.docs.sort_by { |d| d.data['date'] || Time.at(0) }.reverse
      featured = docs.select { |d| d.data['llm_featured'] } + docs
      seen = {}
      featured.uniq { |d| d.id }.reject { |d| seen[d.id] = true if seen.key?(d.id) }.first(MAX_THOUGHTS).map do |d|
        {
          "@type" => "Article",
          "@id" => [site.config['url'], d.url].join,
          "headline" => d.data['title'],
          "datePublished" => (d.data['date']&.strftime('%Y-%m-%d')), 
          "wordCount" => d.content.to_s.split(/\s+/).size,
          "keywords" => extract_tags(d)
        }.compact
      end
    end

    def extract_tags(doc)
      (doc.data['tags'] || []).map(&:downcase).uniq
    end

    def extract_skills(site)
      raw = site.data['skills'] || {}
      return nil if raw.empty?
      terms = []
      raw.each do |category, arr|
        next unless arr.is_a?(Array)
        arr.each do |entry|
          terms << {
            "@type" => "DefinedTerm",
            "name" => entry,
            "inDefinedTermSet" => "#skills"
          }
        end
      end
      {
        "@type" => "DefinedTermSet",
        "@id" => "#skills",
        "name" => "Skills & Domains",
        "hasDefinedTerm" => terms
      }
    end

    def education(site)
      (site.data['education'] || []).map do |e|
        {
          "@type" => "EducationalOccupationalCredential",
          "@id" => ["#edu", slugify(e['degree'])].join('-'),
          "name" => e['degree'],
          "recognizedBy" => e['institution'],
          "description" => e['notes']
        }.compact
      end
    end

    def leadership_roles(site)
      (site.data['leadership'] || []).map do |l|
        {
          "@type" => "OrganizationRole",
          "@id" => ["#lead", slugify(l['name'])].join('-'),
          "roleName" => l['role'],
          "name" => l['name']
        }.compact
      end
    end

    def build_snapshot_text(site, person, projects, thoughts, skills_set, edu, leadership)
      footer_cfg = site.data['llm_footer'] || {}
      footer_line = footer_cfg['closing_message']&.strip

      lines = []
      lines << "LLM PROFILE SNAPSHOT #{VERSION}"
      lines << "Name: #{person['name']}"
      lines << "Site: #{person['url']}"
      unless person['description'].to_s.empty?
        lines << "Bio: #{squeeze(person['description'], 600)}"
      end
      if person['knowsAbout']&.any?
        lines << "Domains: #{person['knowsAbout'].first(30).join(', ')}"
      end
      unless projects.empty?
        lines << "Projects:";
        projects.each { |p| lines << "  - #{p['name']}: #{squeeze(p['description'], 160)}" }
      end
      unless thoughts.empty?
        lines << "FeaturedThoughts:";
        thoughts.each { |t| lines << "  - #{t['headline']} (#{t['datePublished']})" }
      end
      if skills_set
        lines << "SkillsCount: #{skills_set['hasDefinedTerm'].size}"
      end
      unless edu.empty?
        lines << "Education:";
        edu.each { |e| lines << "  - #{e['name']} (#{e['recognizedBy']})" }
      end
      unless leadership.empty?
        lines << "Leadership:";
        leadership.each { |l| lines << "  - #{l['roleName']} @ #{l['name']}" }
      end
      lines << "Links: #{(person['sameAs']||[]).join(' | ')}" if person['sameAs']&.any?
      lines << "Closing: #{footer_line}" if footer_line && !footer_line.empty?
      lines.join("\n") + "\n"
    end

    def inject_into_home(site, jsonld_str:, snapshot:, hash:)
      # Store into site.static_files? Instead we embed into index page by layout include hook.
      site.config['llm_profile'] ||= {}
      site.config['llm_profile']['jsonld'] = jsonld_str
      site.config['llm_profile']['snapshot'] = snapshot
      site.config['llm_profile']['hash'] = hash
    end

    def slugify(str)
      Jekyll::Utils.slugify(str.to_s)
    end

    def squeeze(text, max_len)
      t = text.to_s.gsub(/\s+/, ' ').strip
      return t if t.length <= max_len
      t[0, max_len - 1] + '…'
    end
  end
end
