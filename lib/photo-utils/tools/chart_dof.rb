module PhotoUtils

  class Tools

    class ChartDOF < Tool

      def run

        basic_scene_params = {
          subject_distance: 8.feet,
          sensitivity: 400,
          brightness: 8,
        }

        scene_params = []
        camera_name = ARGV.shift or raise "Must specify camera"
        camera = Camera[camera_name] or raise "Can't find camera #{camera_name.inspect}"
        ((camera.lens.max_aperture.to_v.round)..(camera.lens.min_aperture.to_v.round)).each do |av|
          camera.lens.aperture = ApertureValue.new_from_v(av)
          scene_params << basic_scene_params.merge(camera: camera)
        end

        scenes = scene_params.map do |params|
          params[:description] = '%s (%s): %s @ %s' % [
            camera.name,
            camera.format,
            camera.lens.focal_length,
            camera.lens.aperture,
          ]
          Scene.new(basic_scene_params.merge(params))
        end

        scenes.each do |scene|
          scene.print; puts
        end

        # max_distance = scenes.map { |s| s.depth_of_field.far }.max
        # max_distance = scenes.map { |s| s.hyperfocal_distance }.max
        max_distance = 50.feet

        camera_width  = scenes.map { |s| camera.lens.focal_length }.max
        camera_height = scenes.map { |s| [s.absolute_aperture, camera.format.frame.height].max }.max

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

        output_file = ARGV.first or usage
        Path.new(output_file).write(html.target!)
      end

    end

  end

end