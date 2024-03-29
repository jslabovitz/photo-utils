module PhotoUtils

  class Tools

    class DOFTable < Tool

      def run
        camera = Cameras.generic_35mm
        scene = Scene.new(camera: camera)

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
          print "\t" + scene.field_of_view(scene.subject_distance).to_s(:imperial)
          apertures.each do |aperture|
            scene.aperture = aperture
            scene.calculate_depth_of_field!
            print "\t" + scene.depth_of_field.to_s(:imperial)
          end
          puts
        end
      end

    end

  end

end
