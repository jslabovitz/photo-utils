module PhotoUtils

  class Tools

    class DOFTable < Tool

      def run
        camera = Camera[ARGV.shift] or raise Error, "Unknown camera"

        scene = Scene.new
        scene.camera = camera

        puts
        scene.print_camera
        puts

        # Av equivalents of f/4 ~ f/64
        apertures = (4..12).map { |av| ApertureValue.new_from_v(av) }

        first = true

        1.upto(30) do |subject_distance|
          scene.subject_distance = subject_distance.feet
          if first
            first = false
            puts (['', ''] + apertures.map { |a| a.to_s(:value) }).join("\t")
            puts (['', ''] + apertures.map { |a| a.to_s(:us) }).join("\t")
            puts (['Distance', 'Field of view'] + apertures).join("\t")
          end
          print scene.subject_distance.to_s(:imperial)
          fov = scene.field_of_view(scene.subject_distance)
          print "\t" + "%sH x %sW" % [
            fov.height.to_s(:imperial),
            fov.width.to_s(:imperial),
          ]
          apertures.each do |aperture|
            scene.camera.lens.aperture = aperture
            print "\t" + "%s" % scene.total_depth_of_field.to_s(:imperial)
          end
          puts
        end
      end

    end

  end

end
