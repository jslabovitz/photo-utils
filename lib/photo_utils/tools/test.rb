require 'photo_utils/tool'

module PhotoUtils
  
  class Tools
    
    class Test < Tool
      
      def run(args)
        scene = Scene.new
  
        scene.frame = FORMATS['6x6']
        scene.focal_length = 136.mm
        scene.subject_distance = 15.feet
        scene.sensitivity = 100
        # scene.sensitivity = 3000
        # scene.brightness = 1000   # overcast daylight
        scene.brightness = 300   # open shade
        # scene.aperture = 16
        scene.time = 1.0 / 25
  
        scene.print_exposure
        scene.print_depth_of_field
      end
      
    end
    
  end
  
end