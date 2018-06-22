module PhotoUtils

  class Tools

    class CalcAperture < Tool

      def run
        camera = Camera.generic_35mm
        scene_params = {
          camera: camera,
          subject_distance: 12.feet,
          foreground_distance: 10.feet,
          background_distance: 14.feet,
          brightness: 2000,
          sensitivity: 100,
        }
        camera.lenses.each do |lens|
          scene = Scene.new(scene_params)
          scene.calculate_aperture_for_depth_of_field!
          scene.calculate_exposure!

          # next unless scene.aperture >= lens.max_aperture && scene.aperture <= lens.min_aperture

          # background_fov = scene.field_of_view(scene.background_distance)
          # next unless background_fov.width <= 4.feet && background_fov.height <= 4.feet

          # subject_fov = scene.field_of_view(scene.subject_distance)
          # next unless subject_fov.width >= 2.feet && subject_fov.height >= 2.feet

          # next unless scene.time < 1.0/15

          scene.print
        end

      end

    end

  end

end