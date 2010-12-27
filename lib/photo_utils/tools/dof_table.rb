require 'photo_utils/tool'

module PhotoUtils
  
  class Tools
    
    class DOFTable < Tool
      
      def run(args)
        format = args.shift || '35'
        focal_length = args.shift || '50mm'

        scene = Scene.new
        scene.focal_length = focal_length
        scene.frame = FORMATS[format]
          
        puts
        scene.print_lens_info
        puts
  
        # AV equivalents of f/4 -- f/64
        apertures = (4..12).map { |av| Aperture.new_from_v(av) }
  
        first = true
  
        1.upto(30) do |s|
          scene.subject_distance = s.feet
          if first
            first = false
            puts (['', ''] + apertures.map { |a| "AV #{a.to_v.to_i}" }).join("\t")
            puts (['', ''] + apertures.map { |a| a.to_s(:us) }).join("\t")
            puts (['Distance', 'Field of view'] + apertures).join("\t")
          end
          print scene.subject_distance.to_s(:imperial)
          print "\t" + "#{scene.field_of_view.height.to_s(:imperial)}H x #{scene.field_of_view.width.to_s(:imperial)}W"      
          apertures.each do |a|
            scene.aperture = a
            # print "\t" + "%s (%s ~ %s)" % [scene.total_depth_of_field, scene.near_distance_from_subject, scene.far_distance_from_subject].map { |d| d.to_s(:imperial) }
            print "\t" + "%s" % [scene.total_depth_of_field].map { |d| d.to_s(:imperial) }
          end
          puts
        end
      end
      
    end
    
  end
  
end
