module PhotoUtils

  class Tools

    class Blur < Tool

      def run
        scene = Scene.new
        scene.sensitivity = 100
        scene.subject_distance = 6.feet
        scene.background_distance = 7.feet
        flash_lux = 25
        flash_seconds = 0.001
        # flash_lux_seconds = flash_lux.to_f * (flash_seconds * 1000)
        flash_lux_seconds = 25000 / 2
        scene.brightness = PhotoUtils::Brightness.new_from_cdm2(flash_lux_seconds.to_f / ((scene.subject_distance / 1000) ** 2))
        scene.camera = Camera[/Eastman/]
        # scene.camera.lens = scene.camera.lenses.find { |l| l.focal_length == 12.inches }
        scene.camera.lens.aperture = 32
        scene.camera.shutter = nil

        scene.print_camera
        scene.print_exposure
        scene.print_depth_of_field

        1.feet.step(scene.subject_distance * 2, 1.feet).map { |d| Length.new(d) }.each do |d|
          blur = scene.blur_at_distance(d)
          puts "%12s: blur disk: %7s, blur/CoC: %6d%% -- %s" % [
            d.to_s(:imperial),
            blur.to_s(:metric),
            (blur / scene.circle_of_confusion) * 100,
            blur <= scene.circle_of_confusion ? 'in focus' : 'out of focus'
          ]
        end
      end

    end

  end

end