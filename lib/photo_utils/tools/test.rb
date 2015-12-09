require 'photo_utils/tool'

module PhotoUtils

  class Tools

    class Test < Tool

      def run(args)

        # field_of_view = Frame.new(5.feet, 8.feet)
        subject_distance = 3.feet
        # subject_distance = nil
        # depth_of_field = 2.feet
        depth_of_field = 0.1.feet
        sensitivity = 1600
        # brightness = PhotoUtils::Brightness.new_from_lux(2000)
        # brightness = nil
        # shutter = 1.0/125
        shutter = nil
        # aperture = 4

        header = "%-15.15s | %-15.15s | %-50.50s | %7s | %8s | %14s | %7s | %s"

        puts header % %w{
          camera
          format
          lens
          35mm
          dist
          FOV
          DOF
          aperture
        }

        Camera.cameras.each do |camera|
          # next unless camera.name =~ /Eastman/
          # next unless camera.name =~ /Hasselblad|Bronica|Leica/
          camera.formats.each do |format|
            # next unless format.name =~ /5x7/
            puts
            camera.format = format
            camera.lenses.sort_by(&:focal_length).each do |lens|
              # next unless lens.name =~ /12"/
              camera.lens = lens
              scene = Scene.new
              # scene.sensitivity = sensitivity
              # scene.brightness = brightness
              scene.camera = camera
              scene.camera.shutter = shutter
              scene.subject_distance = subject_distance || scene.subject_distance_for_field_of_view(field_of_view)
              if depth_of_field
                aperture = scene.aperture_for_depth_of_field(scene.subject_distance - (depth_of_field / 2), scene.subject_distance + (depth_of_field / 2))
              end
              scene.camera.lens.aperture = [aperture, scene.camera.lens.max_aperture].max
              scene.camera.lens.aperture = [scene.camera.lens.aperture, scene.camera.lens.min_aperture].min
              scene.set_exposure

              # if scene.working_aperture > 0 && scene.working_aperture < camera.lens.min_aperture
              #   exp_comp = scene.working_aperture.to_v - camera.lens.aperture.to_v
              #   exp_comp = (exp_comp * 2).to_i / 2
              #   exp_comp = if exp_comp < 0
              #     "-#{exp_comp.abs}"
              #   elsif exp_comp > 0
              #     "+#{exp_comp}"
              #   else
              #     nil
              #   end
              # end
              exp_comp = nil

              puts header % [
                scene.camera.name,
                scene.camera.format.to_s(true),
                scene.camera.lens,
                scene.camera.format.focal_length_equivalent(scene.camera.lens.focal_length),
                scene.subject_distance.to_s(:imperial),
                scene.field_of_view(scene.subject_distance).to_s(:imperial),
                scene.total_depth_of_field.to_s(:imperial),
                scene.camera.lens.aperture,
              ]
            end
          end
        end
      end

    end

  end

end
