require 'photo_utils/tool'

module PhotoUtils
  
  class Tools
    
    class DOF < Tool
      
      def run(args)
        
        cameras = []
        cameras << Camera[/Eastman/]
        
        cameras.each do |camera|
  
          scene = Scene.new
          scene.camera = camera
          scene.camera.shutter = 1.0 / 60
          scene.subject_distance = 7.feet
          # scene.camera.lens.aperture = scene.aperture_for_depth_of_field(scene.subject_distance - 3.feet, scene.subject_distance + 3.feet)
          scene.camera.lens.aperture = 45
          scene.sensitivity = 3200
          scene.set_exposure
          
          puts "#{camera.name}"
          puts "\t" + "FOV: #{scene.field_of_view(scene.subject_distance).to_s(:imperial)}"
          puts "\t" + "DOF: #{scene.total_depth_of_field.to_s(:imperial)} (-#{scene.near_distance_from_subject.to_s(:imperial)}/+#{scene.far_distance_from_subject.to_s(:imperial)})"
          puts
        end
      end
      
    end
    
  end
  
end