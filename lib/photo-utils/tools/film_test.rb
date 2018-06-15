module PhotoUtils

  class Tools

    class FilmTest < Tool

      def run
        camera = Camera[ARGV.shift || 'Generic 35mm']

        zone_offset_from_mg = -4
        brightness = BrightnessValue.new_from_v(5 + zone_offset_from_mg)

        # recommendation from Adams' "The Negative"
        # steps = [0, -1.0/3, -2.0/3, -1, 1.0/3, 2.0/3, 1]
        steps = [-2, -1.5, -1, -0.5, 0, 0.5, 1, 1.5, 2]

        steps.each_with_index do |offset, i|
          sensitivity = SensitivityValue.new_from_v(camera.sensitivity.to_v + offset)
          exposure = Exposure.calculate(
            time: camera.shutter,
            aperture: camera.lens.aperture,
            brightness: brightness,
            sensitivity: sensitivity)
          puts "%d | %4s | %10s | %5s | %6s | %s" % [
            i + 1,
            offset,
            sensitivity,
            exposure.aperture,
            exposure.time,
            exposure,
          ]
        end
      end

    end

  end

end