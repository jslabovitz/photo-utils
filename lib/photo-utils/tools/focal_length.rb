module PhotoUtils

  class Tools

    class FocalLength < Tool

      def run
        camera = Camera[ARGV.shift || 'Generic 35mm']
        formats = ARGV.empty? ? %w{1/1.7 APS-C APS-H 35 6x4.5 6x6 6x7 5x7} : ARGV
        formats = formats.map { |f| Format[f] or raise "Unknown format: #{f.inspect}" }
        formats.each do |format|
          puts "%10s: %6s" % [
            format.name,
            camera.focal_length_equivalent(format),
          ]
        end
      end

    end

  end

end