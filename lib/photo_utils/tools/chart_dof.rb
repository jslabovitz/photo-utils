require 'photo_utils/tool'

module PhotoUtils

  class Tools

    class ChartDOF < Tool

      def run

        # set up basic scene

        basic_scene = Scene.new
        basic_scene.subject_distance = 8.feet
        basic_scene.sensitivity = 400
        basic_scene.brightness = 8

        scenes = []

        if false

          scene = basic_scene.dup
          scene.format = Format['35']
          scene.focal_length = 50.mm
          scene.aperture = 2
          scene.description = "#{scene.format}: #{scene.focal_length} @ #{scene.aperture}"
          scenes << scene

          scene = basic_scene.dup
          scene.format = Format['6x6']
          scene.focal_length = 92.mm
          scene.aperture = 8
          scene.description = "#{scene.format}: #{scene.focal_length} @ #{scene.aperture}"
          scenes << scene

          scene = basic_scene.dup
          scene.format = Format['5x7']
          scene.focal_length = 253.mm
          scene.aperture = 64
          scene.description = "#{scene.format}: #{scene.focal_length} @ #{scene.aperture}"
          scenes << scene

        end

        if false

          scene = basic_scene.dup
          scene.format = Format['35']
          scene.focal_length = 90.mm
          scene.aperture = 2.8
          scene.description = "#{scene.format}: #{scene.focal_length} @ #{scene.aperture}"
          scenes << scene

          scene = basic_scene.dup
          scene.format = Format['35']
          scene.focal_length = 90.mm
          scene.aperture = 4
          scene.description = "#{scene.format}: #{scene.focal_length} @ #{scene.aperture}"
          scenes << scene

          scene = basic_scene.dup
          scene.format = Format['35']
          scene.focal_length = 90.mm
          scene.aperture = 5.6
          scene.description = "#{scene.format}: #{scene.focal_length} @ #{scene.aperture}"
          scenes << scene

          scene = basic_scene.dup
          scene.format = Format['35']
          scene.focal_length = 85.mm
          scene.aperture = 4
          scene.description = "#{scene.format}: #{scene.focal_length} @ #{scene.aperture}"
          scenes << scene

          scene = basic_scene.dup
          scene.format = Format['35']
          scene.focal_length = 85.mm
          scene.aperture = 5.6
          scene.description = "#{scene.format}: #{scene.focal_length} @ #{scene.aperture}"
          scenes << scene

        end

        if true

          camera = Camera[/eastman/i] or raise "Can't find camera"
          basic_scene.description = camera.name
          basic_scene.camera = camera

          aperture = camera.lens.max_aperture
          while aperture <= camera.lens.min_aperture
            scene = basic_scene.dup
            camera.lens.aperture = aperture
            # break if scene.time > 1.0/30
            scene.description += ": #{camera.lens.focal_length} @ #{camera.lens.aperture}"
            scenes << scene
            aperture = Aperture.new_from_v(aperture.to_v + 1)
          end

        end

        scenes.each do |scene|
          scene.print; puts
        end

        # max_distance = scenes.map { |s| s.depth_of_field.far }.max
        # max_distance = scenes.map { |s| s.hyperfocal_distance }.max
        max_distance = 50.feet

        camera_width  = scenes.map { |s| s.focal_length }.max
        camera_height = scenes.map { |s| [s.absolute_aperture, s.frame.height].max }.max

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

        raise "Usage: #{$0} output-file.html" unless ARGV.first
        File.open(ARGV.first, 'w') { |f| f.write(html.target!) }

      end

    end

  end

end