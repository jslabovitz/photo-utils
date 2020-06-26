require 'builder'

module PhotoUtils

  class Tools

    class ChartDOF < Tool

      def run
        camera = Cameras.generic_35mm
        lens = camera.normal_lens(camera.primary_format)

        base_scene = Scene.new(
          camera: camera,
          lens: lens,
          subject_distance: 8.feet,
          brightness: 8,
          sensitivity: 100)

        scenes = (lens.max_aperture.to_v.round .. lens.min_aperture.to_v.round).map do |av|
          scene = base_scene.dup(aperture: ApertureValue.new_from_v(av))
          scene.calculate_depth_of_field!
          scene.calculate_exposure!
          scene
        end

        chart = Chart.new(
          scenes: scenes,
          # max_distance: scenes.map { |s| s.depth_of_field.far }.max,
          # max_distance: scenes.map { |s| s.hyperfocal_distance }.max,
          max_distance: 50.feet,
          camera_width: scenes.map(&:focal_length).max,
          camera_height: scenes.map { |s| [s.absolute_aperture, s.sensor_frame.height].max }.max,
        )
        chart.print
      end

      class Chart

        attr_accessor :scenes
        attr_accessor :max_distance
        attr_accessor :camera_width
        attr_accessor :camera_height

        def initialize(**params)
          params.each { |k, v| send("#{k}=", v) }
        end

        def print(io=STDOUT)
          html = Builder::XmlMarkup.new(indent: 2)
          html.declare!(:DOCTYPE, :html)
          html.html do
            html.head {}
            html.body do
              html.table do
                scenes.each do |scene|
                  scene_view = SceneView.new(scene,
                    max_distance: max_distance,
                    camera_width: camera_width)
                  html.tr do
                    html.td do
                      html << (scene.description || '')
                    end
                    html.td do
                      html << scene_view.to_svg
                    end
                  end
                end
              end
            end
          end
          io.print html.target!
        end

      end

      class SceneView

        attr_accessor :scene
        attr_accessor :width
        attr_accessor :height
        attr_accessor :max_distance
        attr_accessor :camera_width
        attr_accessor :camera_height
        attr_accessor :scale

        def initialize(scene, options={})
          @scene = scene
          @width = options[:width] || 900
          @height = options[:height] || 50
          @max_distance = options[:max_distance] || @scene.background_distance
          @camera_width  = options[:camera_width]  || @scene.focal_length
          @camera_height = options[:camera_height] || [@scene.absolute_aperture, @scene.sensor_frame.height].max
          @scale = (@width.to_f - @height) / (@camera_width + @max_distance)
          @camera_scale = [
            @height.to_f / @camera_width,
            @height.to_f / @camera_height
          ].min
        end

        def to_svg
          xml = Builder::XmlMarkup.new(indent: 2)
          xml.svg(width: @width, height: @height) do
            xml.defs do
              1.upto(9).each do |std_dev|
                xml.filter(id: "gb#{std_dev}") do
                  xml.feGaussianBlur(in: 'SourceGraphic', stdDeviation: std_dev)
                end
              end
            end
            xml.g(transform: "translate(#{@height},0)") do
              draw_camera(xml)
              draw_dof(xml)
              draw_subject(xml)
              # draw_hyperfocal(xml)
            end
          end
          xml.target!
        end

        def draw_camera(xml)
          fh2 = (@scene.sensor_frame.height / 2) * @camera_scale
          aa2 = (@scene.absolute_aperture / 2) * @camera_scale
          points = [
            [0, -fh2],
            [@scene.focal_length * @camera_scale, -aa2],
            [@scene.focal_length * @camera_scale, aa2],
            [0, fh2],
          ]
          xml.g(transform: "translate(0,#{@height / 2})") do
            xml.polygon(
              x: -@height,
              y: 0,
              points: points.map { |p| p.join(',') }.join(' '),
              fill: 'black')
          end
        end

        def draw_dof(xml)
          # blur

          if true

            step = @max_distance / 20
            step.step(@max_distance, step).map { |d| Length.new(d) }.each do |d|
              blur = @scene.blur_at_distance(d)
              if blur == 0
                std_dev = 0
              else
                ratio = @scene.circle_of_confusion / blur
                std_dev = [9 - (ratio * 10).to_i, 0].max
              end
              xml.circle(
                cx: d * @scale,
                cy: @height / 2,
                r: (step * @scale) / 2 / 2,
                fill: 'black',
                filter: (std_dev > 0) ? "url(\#gb#{std_dev})" : ())
            end

          else
            step = (@max_distance / @width) * 10
            0.step(@max_distance, step).map { |d| Length.new(d) }.each do |distance|
              blur = @scene.blur_at_distance(distance)
              opacity = [1, @scene.circle_of_confusion / blur].min
              xml.rect(
                x: distance * @scale,
                y: (@height - (@scene.field_of_view(distance).height * @scale)) / 2,
                width: step * @scale,
                height: @scene.field_of_view(distance).height * @scale,
                fill: 'blue',
                'fill-opacity' => opacity)
            end
          end

          # depth of focus area
          xml.rect(
            x: @scene.foreground_distance * @scale,
            y: 0,
            width: @scene.depth_of_field * @scale,
            height: @height,
            stroke: 'blue',
            fill: 'none')
        end

        def draw_subject(xml)
          xml.rect(
            x: @scene.subject_distance * @scale,
            y: 0,
            width: 1,
            height: @height,
            fill: 'red')
        end

        def draw_hyperfocal(xml)
          xml.line(
            x1: @scene.hyperfocal_distance * scale,
            y1: 0,
            x2: @scene.hyperfocal_distance * scale,
            y2: @height,
            stroke: 'green')
        end

      end

    end

  end

end