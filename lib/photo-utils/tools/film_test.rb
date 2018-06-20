module PhotoUtils

  class Tools

    class FilmTest < Tool

      def run
        camera = Camera.generic_35mm

        zone_offset_from_mg = -4
        brightness = BrightnessValue.new_from_v(5 + zone_offset_from_mg)
        sensitivity = SensitivityValue.new(100)

        # recommendation from Adams' "The Negative"
        # steps = [0, -1.0/3, -2.0/3, -1, 1.0/3, 2.0/3, 1]
        steps = [-2, -1.5, -1, -0.5, 0, 0.5, 1, 1.5, 2]

        steps.each_with_index do |offset, i|
          sensitivity = SensitivityValue.new_from_v(sensitivity.to_v + offset)
          scene = Scene.new(
            camera: camera,
            brightness: brightness,
            sensitivity: sensitivity)
          puts "%d | %4s | %10s | %5s | %6s | %s" % [
            i + 1,
            offset,
            scene.sensitivity,
            scene.aperture,
            scene.shutter,
            scene.exposure,
          ]
        end
      end

    end

  end

end