module PhotoUtils

  class Tools

    class FocalLength < Tool

      def run
        camera = Camera.generic_35mm
        primary_format = camera.formats.first
        lens = camera.normal_lens(primary_format)
        other_formats = ARGV.empty? ? %w{1/1.7 APS-C APS-H 35 6x4.5 6x6 6x7 5x7} : ARGV
        other_formats = other_formats.map { |f| Format[f] or raise "Unknown format: #{f.inspect}" }
        other_formats.each do |other_format|
          puts "%10s: %6s" % [
            other_format.name,
            primary_format.focal_length_equivalent(lens.focal_length, other_format),
          ]
        end
      end

    end

  end

end