module PhotoUtils

  class Tools

    class Test < Tool

      def run

        camera = Camera[ARGV.shift || 'Generic 35mm']
        subject_distance = 3.feet
        depth_of_field = 2.feet
        brightness = BrightnessValue.new(2000)
        camera.lenses.each do |lens|
          camera.lens = lens
          scene = Scene.new(
            camera: camera,
            brightness: brightness,
            subject_distance: subject_distance)
          scene.calculate_best_aperture!(depth_of_field)
          scene.calculate!
          scene.print
        end
      end

    end

  end

end
