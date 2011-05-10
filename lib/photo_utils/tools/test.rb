require 'photo_utils/tool'

module PhotoUtils
  
  class Tools
    
    class Test < Tool
      
      def run(args)
        
        camera = Camera[/Eastman/]
        
        fov = Frame.new(4.feet, 3.feet)
        
        camera.formats.each do |format|
          camera.format = format
          camera.lenses.sort_by(&:focal_length).each do |lens|
            camera.lens = lens
              scene = Scene.new
              scene.sensitivity = 3000
              scene.brightness = 100
              scene.camera = camera
              scene.subject_distance = scene.subject_distance_for_field_of_view(fov)
              camera.lens.aperture = scene.aperture_for_depth_of_field(scene.subject_distance - 1.feet, scene.subject_distance + 1.feet)
              camera.shutter = nil
              scene.set_exposure
              
              if scene.working_aperture > 0 && scene.working_aperture < camera.lens.min_aperture
                exp_comp = scene.working_aperture.to_v - camera.lens.aperture.to_v
                exp_comp = (exp_comp * 2).to_i / 2
                exp_comp = if exp_comp < 0
                  "-#{exp_comp.abs}"
                elsif exp_comp > 0
                  "+#{exp_comp}"
                else
                  nil
                end
              end
                  
              puts "%-30.30s | %-50.50s | %-15.15s | %10s | %10s @ %-5.5s %s" % [
                format,
                lens,
                scene.field_of_view(scene.subject_distance).to_s(:imperial),
                scene.subject_distance.to_s(:imperial),
                camera.lens.aperture,
                camera.shutter,
                exp_comp ? "[#{exp_comp} EV]" : ''
              ]
            end
        end
      end
      
    end
    
  end
  
end