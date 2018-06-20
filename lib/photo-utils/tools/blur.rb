module PhotoUtils

  class Tools

    class Blur < Tool

      def run
        camera = Camera.generic_35mm
        scene = Scene.new(
          camera: camera,
          brightness: 2000,
          sensitivity: 100,
          subject_distance: 6.feet,
          foreground_distance: 5.feet,
          background_distance: 7.feet)
        scene.calculate_exposure!
        scene.print
        puts
        1.feet.step(scene.subject_distance * 2, 1.feet).map { |d| Length.new(d) }.each do |distance|
          puts "%12s: %s" % [
            distance.to_s(:imperial),
            scene.in_focus?(distance) ? 'in focus' : '--'
          ]
        end
      end

    end

  end

end