require 'photo_utils/tool'

module PhotoUtils

  class Tools

    class DOFTable < Tool

      def run
        scene = Scene.new
        scene.camera = Camera[/Eastman/]

        puts
        scene.print_camera
        puts

        # Av equivalents of f/4 ~ f/64
        apertures = (4..12).map { |av| Aperture.new_from_v(av) }

        first = true

        1.upto(30) do |s|
          scene.subject_distance = s.feet
          if first
            first = false
            puts (['', ''] + apertures.map { |a| "Av #{a.to_v.to_i}" }).join("\t")
            puts (['', ''] + apertures.map { |a| a.to_s(:us) }).join("\t")
            puts (['Distance', 'Field of view'] + apertures).join("\t")
          end
          print scene.subject_distance.to_s(:imperial)
          print "\t" + "#{scene.field_of_view(scene.subject_distance).height.to_s(:imperial)}H x #{scene.field_of_view(scene.subject_distance).width.to_s(:imperial)}W"
          apertures.each do |a|
            scene.camera.lens.aperture = a
            # print "\t" + "%s (%s ~ %s)" % [scene.total_depth_of_field, scene.near_distance_from_subject, scene.far_distance_from_subject].map { |d| d.to_s(:imperial) }
            print "\t" + "%s" % [scene.total_depth_of_field].map { |d| d.to_s(:imperial) }
          end
          puts
        end
      end

    end

  end

end
