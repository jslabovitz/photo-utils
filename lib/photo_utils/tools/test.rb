require 'photo_utils/tool'

module PhotoUtils
  
  class Tools
    
    class Test < Tool
      
      def run(args)
        
        camera = Camera[/Eastman/]
        fov = Frame.new(6.feet, 3.feet)
        # dof = 4.feet
        sensitivity = 100
        brightness = nil
        aperture = 4.5
        shutter = 1.0/25

        header = "%-20.20s | %-50.50s | %-12.12s | %9s | %7s | %10s | %14s | %5s | %s"
        
        puts header % %w{
          format
          lens
          FOV
          subj-dist
          DOF
          brightness
          exposure
          comp
          APEX
        }
        
        camera.formats.each do |format|
          next unless format.name =~ /5x7/
          camera.format = format
          camera.lenses.sort_by(&:focal_length).each do |lens|
            next unless lens.name =~ /12"/
            camera.lens = lens
            scene = Scene.new
            scene.sensitivity = sensitivity
            # scene.brightness = brightness
            scene.camera = camera
            scene.subject_distance = scene.subject_distance_for_field_of_view(fov)
            # camera.lens.aperture = scene.aperture_for_depth_of_field(scene.subject_distance - (dof / 2), scene.subject_distance + (dof / 2))
            camera.shutter = shutter
            scene.set_exposure
            # ;;scene.print
            
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
                
            puts header % [
              format,
              lens,
              scene.field_of_view(scene.subject_distance).to_s(:imperial),
              scene.subject_distance.to_s(:imperial),
              scene.total_depth_of_field.to_s(:imperial),
              scene.brightness.to_s(:lux_eq),
              '%s @ %s' % [scene.camera.lens.aperture, camera.shutter],
              exp_comp ? "[#{exp_comp} EV]" : '',
              scene.exposure.to_s,
            ]
          end
        end
      end
      
    end
    
  end
  
end