module PhotoUtils

  class Tools

    class Apertures < Tool

      APERTURE_VALUES = 0..11
      FORMATS = ['35', '645', '6x6', '6x7']

      def run
        formats = FORMATS.map { |f| Format[f] }
        apertures = APERTURE_VALUES.map { |a| ApertureValue.new_from_v(a) }

        formats.each do |format|
          print '%6s ' % format
        end
        puts; puts

        apertures.each do |aperture|
          formats.each do |format|
            eq = format.aperture_equivalent(aperture, other=Format['35'])
            print '%6s ' % eq
          end
          puts
        end
      end

    end

  end

end