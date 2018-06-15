module PhotoUtils

  class Tools

    class DOF < Tool

      def run

        camera = Camera[ARGV.shift || 'Generic 35mm']
        camera.shutter = Rational(1, 125)

        puts "#{camera.name}"

        scene = Scene.new(
          camera: camera,
          subject_distance: 30.feet,
          sensitivity: 1600)
        scene.calculate_best_aperture!(1.feet)
        scene.calculate!

        puts "\t" + ' field of view: %s' % scene.field_of_view(scene.subject_distance).to_s(:imperial)
        puts "\t" + 'depth of field: %s (-%s/+%s)' % [
          scene.total_depth_of_field.to_s(:imperial),
          scene.near_distance_from_subject.to_s(:imperial),
          scene.far_distance_from_subject.to_s(:imperial),
        ]
        puts "\t" + '      exposure: %s' % scene.exposure
      end

    end

  end

end
