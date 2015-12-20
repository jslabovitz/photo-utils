require 'photo_utils/tool'

module PhotoUtils

  class Tools

    class DOF < Tool

      def run

        cameras = []
        cameras << Camera[/Bronica/]
        cameras << Camera[/Leica/]
        cameras << Camera[/Hasselblad/]

        cameras.each do |camera|

          puts "#{camera.name}"

          scene = Scene.new
          scene.camera = camera
          scene.camera.shutter = 1.0 / 125
          scene.subject_distance = 30.feet
          dof = 1.feet
          aperture = scene.aperture_for_depth_of_field(scene.subject_distance - (dof / 2), scene.subject_distance + (dof / 2))
          scene.camera.lens.aperture = [aperture, camera.lens.max_aperture].max
          scene.sensitivity = 1600
          scene.set_exposure

          puts "\t" + "FOV: #{scene.field_of_view(scene.subject_distance).to_s(:imperial)}"
          puts "\t" + "DOF: #{scene.total_depth_of_field.to_s(:imperial)} (-#{scene.near_distance_from_subject.to_s(:imperial)}/+#{scene.far_distance_from_subject.to_s(:imperial)})"
          puts

          scene.print_exposure
        end
      end

    end

  end

end
