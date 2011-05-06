require 'photo_utils/tool'

module PhotoUtils
  
  class Tools
    
    class DOF < Tool
      
      def run(args)
        [
          # focal_length, format
          [50, '35'],
          [90, '6x7 Mamiya RB/RZ67'],
          [65, '6x4.5'],
          [45, '6x4.5'],
        ].each do |focal_length, format_name|
  
          scene = Scene.new
          scene.focal_length = focal_length
          scene.format = Format[format_name]
              
          # calculate average brightness, by analyzing test exposures on site
          scene.sensitivity = 1600
          exposures = [
            # aperture, shutter sheed
            [4, 30],
          ]
          brightnesses = []
          exposures.each do |aperture, time|
            scene.aperture = aperture
            scene.time = 1.0 / time
            brightnesses << scene.brightness
          end
          scene.brightness = brightnesses.mean
  
          scene.sensitivity = 1600
          scene.aperture = nil
          scene.time = nil
  
          # apertures = [4, 5.6, 8, 11, 16]
          apertures = [2.8]
  
          closest_focus = 20 # feet
          farthest_focus = 50 # feet
  
          closest_focus.upto(farthest_focus).each do |feet|
            scene.subject_distance = feet.feet
    
            puts "\t\t" + "subject_distance: #{scene.subject_distance.to_s(:imperial)}"
    
            apertures.each do |aperture|
              scene.aperture = aperture
              
              # capture most of a face
              next if scene.total_depth_of_field < 8.inches
        
              # rule of thumb: shutter speed (in fractions of a second) should be at least the focal length (in mm)
              next if 1/scene.time < scene.focal_length
        
              # but I can usually hand-hold to 1/30
              next if scene.time < 1.0/30
              
              puts "\t\t\t" + [
                "#{scene.aperture} @ #{scene.time}",
                scene.exposure,
                "#{scene.total_depth_of_field.to_s(:imperial)} (-#{scene.near_distance_from_subject.to_s(:imperial)} .. +#{scene.far_distance_from_subject.to_s(:imperial)})"
              ].join("\t")        
            end
          end
        end
      end
      
    end
    
  end
  
end