require 'photo_utils/tool'

module PhotoUtils
  
  class Tools
    
    class FilmTest < Tool
      
      def run(args)
        camera = Camera['RB67']
        lens = camera.lenses.find { |l| l.focal_length == 90 }
        
        scene = Scene.new
        scene.format = camera.format
        scene.sensitivity = 100
        scene.time = 1.0/60
        scene.aperture = 5.6
        scene.description = "film: Acros 100; flash: Metz 60 at 1/128~1/256 power; dev: 11m in HC-110 (H) @ 68"
        
        scene.print_exposure
        
        zone_offset_from_mg = -4
        
        # recommendation from Adams' "The Negative"
        # steps = [0, -1.0/3, -2.0/3, -1, 1.0/3, 2.0/3, 1]
        steps = [0, -0.5, -1, -1.5, -2, 0.5, 1, 1.5, 2]
        
        scenes = []
  
        base_fog = Scene.new
        base_fog.description = "base + fog"
        scenes << base_fog
  
        steps.each do |i|
          scene2 = scene.dup
          scene2.brightness = PhotoUtils::Brightness.new_from_v(scene.brightness.to_v - zone_offset_from_mg)
          scene2.sensitivity = Sensitivity.new_from_v(scene.sensitivity.to_v + i)
          scene2.calculate_best_exposure(lens)
          scene2.description = "#{scene2.sensitivity} (#{i}) [#{scene2.exposure}]"
          scenes << scene2
        end
  
        scenes.each_with_index do |scene2, i|
          begin
            aperture = scene2.aperture
            time     = scene2.time
          rescue => e
            aperture = time = nil
          end
    
          puts "%2d | %-25.25s | %12s | %5s" % [
            i + 1,
            scene2.description,
            aperture || '--',
            time     || '--'
          ]
        end
      end
      
    end
    
  end
  
end