module PhotoUtils

  class Tools

    class ChartDOF < Tool

      def run
        camera = Camera[ARGV.shift || 'Generic 35mm']
        lens = camera.normal_lens(camera.formats.first)

        basic_scene = Scene.new(
          subject_distance: 8.feet,
          sensitivity: 400,
          brightness: 8,
          camera: camera)

        scenes = []

        (lens.max_aperture.to_v.round .. lens.min_aperture.to_v.round).each do |av|
          scene = basic_scene.dup
          scene.camera.lens.aperture = ApertureValue.new_from_v(av)
          scene.calculate!
          scene.print
          puts
        end

        # max_distance = scenes.map { |s| s.depth_of_field.far }.max
        # max_distance = scenes.map { |s| s.hyperfocal_distance }.max
        max_distance = 50.feet

        camera_width  = scenes.map { |s| s.camera.lens.focal_length }.max
        camera_height = scenes.map { |s| [s.camera.lens.absolute_aperture, s.camera.format.frame.height].max }.max

        html = Builder::XmlMarkup.new(indent: 2)
        html.declare!(:DOCTYPE, :html)
        html.html do
          html.head {}
          html.body do
            html.table do
              scenes.each do |scene|
                scene_view = SceneView.new(scene,
                  max_distance: max_distance,
                  camera_width: camera_width,
                  camera_height: camera_height)
                html.tr do
                  html.td do
                    html << scene.description
                  end
                  html.td do
                    html << scene_view.to_svg
                  end
                end
              end
            end
          end
        end
        print html.target!
      end

    end

  end

end