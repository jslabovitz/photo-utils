module PhotoUtils

  class Tools

    class Apertures < Tool

      APERTURE_VALUES = 0..11
      FRAMES = ['135', '6x4.5', '6x6', '6x7']

      def run
        frames = FRAMES.map { |f| Frames[f] or raise "Can't find frame key: #{f.inspect}" }
        apertures = APERTURE_VALUES.map { |a| ApertureValue.new_from_v(a) }

        frames.each do |frame|
          print '%6s ' % frame
        end
        puts; puts

        apertures.each do |aperture|
          frames.each do |frame|
            eq = frame.aperture_equivalent(aperture, other=Frames['135'])
            print '%6s ' % eq
          end
          puts
        end
      end

    end

  end

end