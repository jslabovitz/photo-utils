module PhotoUtils

  class Tools

    class DOF < Tool

      def run
        camera = Camera.generic_35mm
        scene = Scene.new(
          camera: camera,
          subject_distance: 30.feet,
          foreground_distance: 29.feet,
          background_distance: 31.feet,
          sensitivity: 100,
          brightness: 2000)
        scene.calculate_aperture_for_depth_of_field!
        scene.calculate_exposure!
        scene.print
      end

    end

  end

end
