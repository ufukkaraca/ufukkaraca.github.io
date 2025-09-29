require 'fileutils'

# SVG-based OG image generator (no ImageMagick dependency)
# Creates one SVG per thought in /assets/og/thought-<slug>.svg written to site.dest.
# Uses simple word wrapping based on character count approximation.

module Jekyll
  class OgImageGenerator < Generator
    safe true
    priority :low

    WIDTH  = 1200
    HEIGHT = 630

    def generate(site)
      collection = site.collections['thoughts']
      return unless collection
      thoughts = collection.docs
      return if thoughts.empty?

      # Write generated images into the built site so they are deployed
      out_dir = File.join(site.dest, 'assets', 'og')
      FileUtils.mkdir_p(out_dir)

      # Config
      font_family_title = site.config.dig('og_image', 'font_family_title') || 'Georgia, serif'
      font_family_meta  = site.config.dig('og_image', 'font_family_meta')  || 'Helvetica, Arial, sans-serif'
      pointsize_title = site.config.dig('og_image', 'title_pointsize') || 72
      pointsize_meta  = site.config.dig('og_image', 'meta_pointsize') || 36
      background      = site.config.dig('og_image', 'background') || '#111111'
      title_color     = site.config.dig('og_image', 'title_color') || '#FFFFFF'
      meta_color      = site.config.dig('og_image', 'meta_color') || '#BBBBBB'
      max_chars       = site.config.dig('og_image', 'title_line_chars') || 26
      line_height_mult = site.config.dig('og_image', 'title_line_height') || 1.12

      thoughts.each do |doc|
        slug = Jekyll::Utils.slugify(doc.data['slug'] || doc.data['title'] || doc.basename_without_ext)
        filename = "thought-#{slug}.svg"
        rel_path = File.join('/assets/og', filename)
        abs_path = File.join(out_dir, filename)

        # Skip if already exists (allow manual override) unless force flag
        if File.exist?(abs_path)
          doc.data['social_image'] ||= rel_path
          next
        end

        title = (doc.data['title'] || slug).to_s.strip
        date  = doc.data['date'] ? doc.data['date'].strftime('%Y-%m-%d') : ''
        author = site.config['author'].to_s
        meta_line = [date, author].reject(&:empty?).join(' • ')
        lines = wrap_title(title, max_chars)
        svg = build_svg(
          width: WIDTH,
          height: HEIGHT,
          background: background,
          lines: lines,
          title_color: title_color,
          meta_color: meta_color,
          pointsize_title: pointsize_title,
          pointsize_meta: pointsize_meta,
          font_family_title: font_family_title,
          font_family_meta: font_family_meta,
          line_height_mult: line_height_mult,
          meta_line: meta_line
        )
        File.write(abs_path, svg)

        doc.data['social_image'] = rel_path
        Jekyll.logger.info "OGImage", "Generated #{rel_path}"
      rescue => e
        Jekyll.logger.error "OGImage", "Failed for #{doc.path}: #{e.class} #{e.message}"
      end
    end

    private
    def wrap_title(text, max_chars)
      words = text.split(/\s+/)
      lines = []
      current = ''
      words.each do |w|
        if current.empty?
          current = w
        elsif (current.length + 1 + w.length) <= max_chars
          current << ' ' << w
        else
          lines << current
          current = w
        end
      end
      lines << current unless current.empty?
      lines
    end

    def escape_html(str)
      str.to_s.gsub('&','&amp;').gsub('<','&lt;').gsub('>','&gt;').gsub('"','&quot;').gsub("'","&#39;")
    end

    def build_svg(width:, height:, background:, lines:, title_color:, meta_color:, pointsize_title:, pointsize_meta:, font_family_title:, font_family_meta:, line_height_mult:, meta_line:)
      padding_x = 80
      start_y = 120
      svg_lines = []
      lines.each_with_index do |line, idx|
        y = start_y + (idx * (pointsize_title * line_height_mult))
        svg_lines << %(<text x="#{padding_x}" y="#{y}" fill="#{title_color}" font-family="#{escape_html(font_family_title)}" font-size="#{pointsize_title}" font-weight="600">#{escape_html(line)}</text>)
      end
      unless meta_line.empty?
        svg_lines << %(<text x="#{padding_x}" y="#{height - 80}" fill="#{meta_color}" font-family="#{escape_html(font_family_meta)}" font-size="#{pointsize_meta}" font-weight="400">#{escape_html(meta_line)}</text>)
      end
      <<~SVG
      <svg xmlns="http://www.w3.org/2000/svg" width="#{width}" height="#{height}" viewBox="0 0 #{width} #{height}" role="img" aria-label="Open graph image">
        <rect width="100%" height="100%" fill="#{background}"/>
        #{svg_lines.join("\n        ")}
      </svg>
      SVG
    end
  end
end
