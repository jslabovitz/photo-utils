require 'photo_utils/tool'

module PhotoUtils
  
  class Tools
    
    class Brightness < Tool
      
      def run(args)
        camera = Camera['Ikon'] or raise "Can't find camera"
        lens = camera.lenses.find { |l| l.focal_length == 85 } or raise "Can't find lens"
        scene = Scene.new
        scene.format = FORMATS[camera.format]
        scene.sensitivity = 1600
        scene.time = 1.0/60
        scene.aperture = 2.8
        scene.description = "Salon L'Orient"
        scene.print_exposure
      end
      
    end
    
  end
  
end