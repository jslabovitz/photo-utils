module PhotoUtils

  class Tools

    class DOF < Tool

      def run
        camera = Cameras.generic_35mm
        base_scene = Scene.new(
          camera: camera,
          subject_distance: 3.feet,
          foreground_distance: 2.feet,
          background_distance: 4.feet,
          # brightness: 700,
          sensitivity: 6400)
        camera.lenses.each do |lens|
          scene = base_scene.dup(
            focal_length: lens.focal_length,
            shutter: TimeValue.new(1.0/(2 * lens.focal_length)))
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