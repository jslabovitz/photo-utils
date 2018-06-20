module PhotoUtils

  class Tools

    class Test < Tool

      def run
        camera = Camera.generic_35mm
        scene_params = {
          subject_distance: 3.feet,
          foreground_distance: 2.feet,
          background_distance: 4.feet,
          brightness: 2000,
          sensitivity: 100,
        }
        camera.lenses.each do |lens|
          scene = Scene.new(camera: camera, lens: lens, **scene_params)
          scene.calculate_aperture_for_depth_of_field!
          scene.calculate_exposure!
          scene.print
        end
      end

    end

  end

end
