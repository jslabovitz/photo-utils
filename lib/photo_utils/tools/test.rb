require 'photo_utils/tool'

module PhotoUtils
  
  class Tools
    
    class Test < Tool
      
      def run(args)
        scene = Scene.new
        
        scene.camera = Camera[/Eastman/]
        scene.camera.shutter = 1.0/60
        
        scene.subject_distance = 15.feet

        scene.sensitivity = 3000
        scene.brightness = 100
        
        scene.print_camera
        scene.print_exposure
        scene.print_depth_of_field
      end
      
    end
    
  end
  
end