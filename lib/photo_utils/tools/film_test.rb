require 'photo_utils/tool'

module PhotoUtils

  class Tools

    class FilmTest < Tool

      def run
        camera = Camera['Hasselblad']

        scene = Scene.new
        scene.camera = camera
        scene.sensitivity = 100
        scene.camera.shutter = 1.0/60
        scene.camera.lens.aperture = 5.6
        # scene.description = "film: Acros 100; flash: Metz 60 at 1/128~1/256 power; dev: 11m in HC-110 (H) @ 68"

        scene.print_exposure

        zone_offset_from_mg = -4

        # recommendation from Adams' "The Negative"
        # steps = [0, -1.0/3, -2.0/3, -1, 1.0/3, 2.0/3, 1]
        steps = [-2, -1.5, -1, -0.5, 0, 0.5, 1, 1.5, 2]

        scenes = []

        base_fog = Scene.new
        base_fog.description = "base + fog"
        scenes << base_fog

        steps.each do |i|
          scene2 = scene.dup
          scene2.brightness = PhotoUtils::Brightness.new_from_v(scene.brightness.to_v - zone_offset_from_mg)
          scene2.sensitivity = Sensitivity.new_from_v(scene.sensitivity.to_v + i)
          # FIXME: scene2.calculate_best_exposure
          scene2.description = i.to_s
          scenes << scene2
        end

        scenes.each_with_index do |scene2, i|
          puts "%2d | %5s | %10s | %10s | %12s | %12s" % [
            i + 1,
            scene2.description,
            scene2.sensitivity,
            scene2.exposure.aperture,
            scene2.exposure.time,
          ]
        end
      end

    end

  end

end