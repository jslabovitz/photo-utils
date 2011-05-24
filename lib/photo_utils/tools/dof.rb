require 'photo_utils/tool'

module PhotoUtils
  
  class Tools
    
    class DOF < Tool
      
      def run(args)
        
        cameras = []
        cameras << Camera[/R-D1/]
        cameras[-1].lens = cameras[-1].lenses.find { |l| l.focal_length == 50.mm }

        cameras << Camera[/Ikon/]
        cameras[-1].lens = cameras[-1].lenses.find { |l| l.focal_length == 85.mm }

        cameras << Camera[/RF645/]
        cameras[-1].lens = cameras[-1].lenses.find { |l| l.focal_length == 100.mm }
        
        cameras << Camera[/C330/]
        cameras[-1].lens = cameras[-1].lenses.find { |l| l.focal_length == 180.mm }
        
        cameras.each do |camera|
  
          scene = Scene.new
          scene.camera = camera
          scene.camera.shutter = 1.0 / 125
          scene.subject_distance = 25.feet
          # scene.camera.lens.aperture = scene.aperture_for_depth_of_field(scene.subject_distance - 3.feet, scene.subject_distance + 3.feet)
          scene.camera.lens.aperture = 4.5
          scene.sensitivity = 1600
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