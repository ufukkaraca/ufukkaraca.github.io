require 'fileutils'
begin
  require 'mini_magick'
rescue LoadError
  Jekyll.logger.warn "OGImage", "mini_magick gem missing; skipping card generation"
end

module Jekyll
  class OgImageGenerator < Generator
    safe true
    priority :low

  WIDTH  = 1200
  HEIGHT = 600 # Use 2:1 aspect ratio for Twitter summary_large_image to avoid letterboxing

    def generate(site)
      return unless defined?(MiniMagick)
      # Detect ImageMagick / GraphicsMagick CLI
      has_im = system('convert -version > /dev/null 2>&1') || system('magick -version > /dev/null 2>&1') || system('gm version > /dev/null 2>&1')
      unless has_im
        Jekyll.logger.warn "OGImage", "Skipping generation (ImageMagick/GraphicsMagick not installed)"
        return
      end

      collection = site.collections['thoughts']
      return unless collection
      thoughts = collection.docs
      return if thoughts.empty?

      persist = site.config.dig('og_image', 'persist_to_source')
      source_dir = File.join(site.source, 'assets', 'og')
      build_dir  = File.join(site.dest,   'assets', 'og')
      if persist
        FileUtils.mkdir_p(source_dir)
      end
      FileUtils.mkdir_p(build_dir)

      # Config (PNG generation)
      font_family_title = site.config.dig('og_image', 'font_family_title') || 'Helvetica'
      font_family_meta  = site.config.dig('og_image', 'font_family_meta')  || 'Helvetica'
      pointsize_title   = site.config.dig('og_image', 'title_pointsize') || 72
      pointsize_meta    = site.config.dig('og_image', 'meta_pointsize') || 36
      background        = site.config.dig('og_image', 'background') || '#111111'
      title_color       = site.config.dig('og_image', 'title_color') || '#FFFFFF'
      meta_color        = site.config.dig('og_image', 'meta_color') || '#BBBBBB'
      max_chars         = site.config.dig('og_image', 'title_line_chars') || 26
      max_lines         = site.config.dig('og_image', 'title_max_lines') || 3
      line_height_mult  = site.config.dig('og_image', 'title_line_height') || 1.12
      bottom_padding    = 70

      thoughts.each do |doc|
        slug = Jekyll::Utils.slugify(doc.data['slug'] || doc.data['title'] || doc.basename_without_ext)
  filename = "thought-#{slug}.png"
  rel_path = File.join('/assets/og', filename)
  abs_source = File.join(source_dir, filename)
  abs_build  = File.join(build_dir, filename)

        # Skip if already exists (allow manual override) unless force flag
        if persist && File.exist?(abs_source)
          # Already persisted; copy into build dir if missing
          FileUtils.cp(abs_source, abs_build) unless File.exist?(abs_build)
          doc.data['social_image'] ||= rel_path
          doc.data['social_image_alt'] ||= "Thought: #{title} — #{date} by #{author}".strip
          next
        elsif !persist && File.exist?(abs_build)
          doc.data['social_image'] ||= rel_path
          doc.data['social_image_alt'] ||= "Thought: #{title} — #{date} by #{author}".strip
          next
        end

        title = (doc.data['title'] || slug).to_s.strip
        date  = doc.data['date'] ? doc.data['date'].strftime('%Y-%m-%d') : ''
        author = site.config['author'].to_s
        meta_line = [date, author].reject(&:empty?).join(' • ')
        lines = wrap_title(title, max_chars, max_lines)

        # Create blank canvas
        MiniMagick::Tool::Convert.new do |c|
          c.size "#{WIDTH}x#{HEIGHT}"
          c.xc background
          c << (persist ? abs_source : abs_build)
        end

        image = MiniMagick::Image.open(persist ? abs_source : abs_build)
        draw_cmds = []
        start_y = 140
        lines.each_with_index do |line, idx|
          y = start_y + (idx * (pointsize_title * line_height_mult))
          draw_cmds << "text 80,#{y} '#{escape_draw(line)}'"
        end
        unless meta_line.empty?
          meta_y = HEIGHT - bottom_padding
          draw_cmds << "fill '#{meta_color}' font-size #{pointsize_meta} text 80,#{meta_y} '#{escape_draw(meta_line)}'"
        end
        # Combine draw operations; set font & fill for title before drawing
        image.combine_options do |c|
          c.fill title_color
          c.font font_family_title if font_family_title
          c.pointsize pointsize_title
          draw_cmds.each do |dc|
            c.draw dc
          end
        end
        image.write(persist ? abs_source : abs_build)

        # If persisted, also ensure build copy
        if persist
          FileUtils.cp(abs_source, abs_build)
        end

        # Alt text for accessibility / twitter:image:alt
        doc.data['social_image_alt'] = "Thought: #{title} — #{date} by #{author}".strip

  doc.data['social_image'] = rel_path
  Jekyll.logger.info "OGImage", "Generated #{rel_path}#{persist ? ' (persisted)' : ''}"
      rescue => e
        Jekyll.logger.error "OGImage", "Failed for #{doc.path}: #{e.class} #{e.message}"
      end
    end

    private
    def wrap_title(text, max_chars, max_lines)
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
          break if lines.size >= max_lines
        end
        break if lines.size >= max_lines
      end
      lines << current unless current.empty? || lines.size >= max_lines
      if lines.size > max_lines
        lines = lines.first(max_lines)
      end
      if lines.size == max_lines && (words.join(' ').length > lines.join(' ').length)
        # Add ellipsis to last line if truncated
        lines[-1] = lines[-1].sub(/.{1,3}$/,'') + '…' unless lines[-1].end_with?('…')
      end
      lines
    end

    def escape_draw(str)
      # Escape single quotes for ImageMagick draw text
      str.to_s.gsub("'","\\'")
    end
  end
end
