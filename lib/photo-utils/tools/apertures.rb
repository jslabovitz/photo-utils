module PhotoUtils

  class Tools

    class Apertures < Tool

      def run
        aperture_values = 0..11
        format_keys = %w{135 6x4.5 6x6 6x7}
        frames = format_keys.map { |f| Formats[f] or raise "Can't find format: #{f.inspect}" }
        apertures = aperture_values.map { |a| ApertureValue.new_from_v(a) }

        frames.each do |frame|
          print '%6s ' % frame
        end
        puts; puts

        apertures.each do |aperture|
          frames.each do |frame|
            eq = frame.aperture_equivalent(aperture, other=Formats['135'])
            print '%6s ' % eq
          end
          puts
        end
      end

    end

  end

end