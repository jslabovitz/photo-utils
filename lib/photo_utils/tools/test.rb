require 'photo_utils/tool'

module PhotoUtils
  
  class Tools
    
    class Test < Tool
      
      def run(args)
        scene = Scene.new
  
        scene.subject_distance = 30.feet
        scene.sensitivity = 3200
        scene.brightness = 2
  
        if false
          scene.frame = FORMATS['6x6']
          scene.focal_length = 165.mm
          scene.aperture = 4.5
        else
          scene.frame = FORMATS['35']
          scene.focal_length = 90.mm
          scene.aperture = 2.8
        end
  
        scene.print_exposure
        scene.print_depth_of_field
      end
      
    end
    
  end
  
end