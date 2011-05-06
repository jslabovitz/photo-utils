require 'photo_utils/tool'

module PhotoUtils
  
  class Tools
    
    class Blur < Tool
      
      def run(args)
        scene = Scene.new
        scene.subject_distance = 30.feet
        scene.sensitivity = 1600
        scene.brightness = 64
        
        scene.format = Format['6x6']
        scene.focal_length = 80.mm
        scene.aperture = 4
        scene.print_exposure
        scene.print_depth_of_field
  
        1.step(100, 10).map { |d| d.feet }.each do |d|
          blur = scene.blur_at_distance(d)
          puts "%12s: blur disk: %3f, coc/blur: %3f -- %s" % [
            d.to_s(:imperial), 
            blur,
            scene.circle_of_confusion / blur,
            blur <= scene.circle_of_confusion ? 'in focus' : 'out of focus'
          ]
        end
      end
      
    end
    
  end
  
end