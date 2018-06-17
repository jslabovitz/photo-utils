module PhotoUtils

  class Tools

    class Blur < Tool

      def run
        camera = Camera[ARGV.shift || 'Generic 35mm']
        scene = Scene.new(
          camera: camera,
          subject_distance: 6.feet)
        scene.brightness = BrightnessValue.new(2000)

        scene.camera.print
        scene.print_exposure
        scene.print_depth_of_field

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