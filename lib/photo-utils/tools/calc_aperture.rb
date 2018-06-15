module PhotoUtils

  class Tools

    class CalcAperture < Tool

      def run
        camera = Camera[ARGV.shift || 'Generic 35mm']

        # set up basic scene

        basic_scene = Scene.new
        basic_scene.camera = camera
        basic_scene.subject_distance = 12.feet
        basic_scene.background_distance = 14.feet
        basic_scene.description = camera.name

        puts "--- @ #{basic_scene.subject_distance.to_s(:imperial)}"
        camera.lenses.each do |lens|
          scene = basic_scene.dup
          # scene.shutter = nil
          scene.calculate!
          # scene.aperture = scene.aperture_for_depth_of_field(scene.subject_distance - 9.inches, scene.subject_distance + 9.inches)
          # next unless scene.aperture >= lens.max_aperture && scene.aperture <= lens.min_aperture
          # background_fov = scene.field_of_view(scene.background_distance)
          # next unless background_fov.width <= 4.feet && background_fov.height <= 4.feet
          # subject_fov = scene.field_of_view(scene.subject_distance)
          # next unless subject_fov.width >= 2.feet && subject_fov.height >= 2.feet
          # next unless scene.time < 1.0/15
          scene.description += ": #{scene.camera.lens.focal_length} @ #{scene.camera.lens.aperture}"
          puts "#{scene.description}:"
          scene.print_depth_of_field
          scene.print_exposure
          puts
        end

      end

    end

  end

end