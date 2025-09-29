require 'fileutils'
begin
  require 'mini_magick'
rescue LoadError
  Jekyll.logger.warn "OGImage", "mini_magick not available; skipping OG image generation"
end

module Jekyll
  class OgImageGenerator < Generator
    safe true
    priority :low

    WIDTH  = 1200
    HEIGHT = 630

    def generate(site)
      return unless defined?(MiniMagick)
      thoughts = site.collections.dig('thoughts', 'docs') || []
      return if thoughts.empty?

      out_dir = File.join(site.source, 'assets', 'og')
      FileUtils.mkdir_p(out_dir)

      font = site.config.dig('og_image', 'font') # optional
      pointsize_title = site.config.dig('og_image', 'title_pointsize') || 72
      pointsize_meta  = site.config.dig('og_image', 'meta_pointsize') || 36
      background      = site.config.dig('og_image', 'background') || '#111111'
      title_color     = site.config.dig('og_image', 'title_color') || '#FFFFFF'
      meta_color      = site.config.dig('og_image', 'meta_color') || '#BBBBBB'

      thoughts.each do |doc|
        slug = Jekyll::Utils.slugify(doc.data['slug'] || doc.data['title'] || doc.basename_without_ext)
        filename = "thought-#{slug}.png"
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

        # Use a simple two-step image build: base canvas then annotate blocks for title & meta
        MiniMagick::Tool::Convert.new do |c|
          c.size "#{WIDTH}x#{HEIGHT}"
          c.xc background
          c.gravity 'NorthWest'
          c.fill title_color
          c.font font if font
          c.pointsize pointsize_title
          # Title box with wrapping using caption to auto-wrap width (minus padding)
          c.draw "rectangle 0,0 #{WIDTH},#{HEIGHT}" # ensure background fill
          # Create caption for title
          c << "(" << "-background" << background << '-fill' << title_color << '-font' << font if font
          c << '-size' << "#{WIDTH - 160}x" << "caption:#{escape_caption(title)}" << ")"
          # Composite title at padding (80,80)
          c.geometry '+80+80'
          c.composite
        end

        # Annotate meta line (simpler separate command)
        image = MiniMagick::Image.open(abs_path)
        image.combine_options do |c|
          c.fill meta_color
          c.font font if font
          c.pointsize pointsize_meta
          c.gravity 'SouthWest'
          c.draw "text 80,60 '#{escape_text(meta_line)}'"
        end
        image.write(abs_path)

        doc.data['social_image'] = rel_path
        Jekyll.logger.info "OGImage", "Generated #{rel_path}"
      rescue => e
        Jekyll.logger.error "OGImage", "Failed for #{doc.path}: #{e.class} #{e.message}"
      end
    end

    private

    def escape_caption(text)
      # Escape newlines & colons minimally for ImageMagick caption
      text.gsub(':', '\\:')
    end

    def escape_text(text)
      text.gsub("'", "\\'")
    end
  end
end
