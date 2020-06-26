module PhotoUtils

  class Tools

    class Compare < Tool

      def run
        # given:
        #   an image file with EXIF data
        #     extract:
        #       aperture/speed/sensitivity/bias
        #       format (eg, APS-C)
        #       lens focal length (in that format)
        #       post-process exposure adjustment (from XMP data)
        #     estimate width/height
        #     desired minimum shutter
        #  calculate
        #    Ev100
        #    subject distance
        #    depth of field
        #    height or width (not given)
        #    focal length required in 35mm
        #    aperture required for equivalent depth of field
        #    (warn if shutter changes)
        #
        # scenes:
        #   stage performance at medium / far
        #   portrait at close / medium

        #FIXME: Ugh

        $min_sensitivity = SensitivityValue.new(100)
        $max_sensitivity = SensitivityValue.new(1600)
        $max_angle_of_view_delta = Angle.new(5)
        $max_subject_distance_delta = 6.feet

        shots = %q{

          # frame    shutter  aperture  focal length   sensitivity  width DoF   description

          FF         1/125    f/8       50mm           400          150'  50'   Tokyo cityscape
          FF         1/125    f/8       50mm           400          15'   10'   man in street
          FF         1/125    f/8       50mm           400          7'    4'    plants at corner
          FF         1/125    f/8       50mm           400          14"   3"    eggs

        }.split(/\n/).map { |line|
          line.gsub!(/^\s+|\s+$/, '')
          line.sub!(/#.*/, '')
          if line.empty?
            nil
          else
            frame, shutter, aperture, focal_length, sensitivity, width, dof, description = line.split(/\s+/, 8)
            HashStruct.new(
              frame: (Frames[frame] or raise "Unknown frame key: #{frame.inspect}"),
              shutter: TimeValue.new(shutter),
              aperture: ApertureValue.new(aperture),
              focal_length: Length.new(focal_length),
              sensitivity: SensitivityValue.new(sensitivity),
              width: Length.new(width),
              dof: Length.new(dof),
              description: description)
          end
        }.compact

        # FIXME: Ugh

        def validate(scene, camera, lens, subject_distance_delta, angle_of_view_delta)

          #
          # validate subject distance delta
          #

          if subject_distance_delta > $max_subject_distance_delta
            raise "subject distance delta too different (#{subject_distance_delta.to_s(:imperial)} > #{$max_subject_distance_delta.to_s(:imperial)})"
          end

          #
          # validate aperture
          #

          if scene.aperture > lens.min_aperture || scene.aperture < lens.max_aperture
            raise "aperture out of range (#{scene.aperture} != #{lens.max_aperture} .. #{lens.min_aperture})"
          end

          #
          # validate angle of view
          #

          if angle_of_view_delta > $max_angle_of_view_delta
            raise "angle of view too different (#{angle_of_view_delta} > #{$max_angle_of_view_delta})"
          end

          # if scene.angle_of_view - scene.angle_of_view > $max_angle_of_view_delta
          #   raise "angle of view too wide (#{scene2.angle_of_view} > #{scene.angle_of_view})"
          #   next
          # end

          #
          # validate shutter
          #

          if scene.shutter > camera.max_shutter
            raise "shutter too slow (#{scene.shutter} < #{camera.max_shutter})"
          end

        end

        successes = {}

        shots.each do |shot|

          scene = Scene.new
          scene.sensor_frame = shot.frame
          scene.description = shot.description
          scene.aperture = shot.aperture
          scene.sensitivity = shot.sensitivity
          scene.shutter = shot.shutter
          scene.focal_length = shot.focal_length

          # d = w * f / s
          scene.subject_distance = Length.new(shot.width * (scene.focal_length / scene.sensor_frame.width))

          scene.calculate_depth_of_field!
          scene.calculate_exposure!

          scene.print

          # now compute equivalent scene for each camera

          Cameras.each do |camera|

            scene2 = Scene.new
            scene2.sensor_frame = camera.primary_format.frame
            scene2.aperture = scene.aperture
            scene2.brightness = scene.brightness
            scene2.sensitivity = scene.sensitivity

            # find the lens that would best fit

            found = false

            # NOTE: #uniq doesn't work well with delegate classes, so we cast the focal length to a float first
            focal_lengths = camera.lenses.collect { |lens| lens.focal_length.to_f }.sort.reverse.uniq

            focal_lengths.each do |focal_length|

              lenses = camera.lenses.select { |lens| lens.focal_length == focal_length }.sort_by { |lens| lens.max_aperture }.reverse

              lenses.each do |lens|

                scene2.focal_length = lens.focal_length

                # keeping subject width the same, compute new distance from given focal length

                #    o     i
                #   --- = ---
                #    d     f
                #
                # f = focal length
                # d = subject distance
                # o = subject dimension
                # i = frame dimension

                scene2.subject_distance = 1 / ((scene2.sensor_frame.width / scene2.focal_length) / shot.width)

                #
                # calculate depth of field
                #

                scene2.foreground_distance = scene2.subject_distance - (shot.dof / 2)
                scene2.background_distance = scene2.subject_distance + (shot.dof / 2)
                scene2.calculate_aperture_for_depth_of_field!

                #
                # adjust aperture
                #

                # ;;a = scene2.aperture
                # round aperture to closest 1/2 stop
                scene2.aperture = ApertureValue.new_from_v((scene2.aperture.to_v / 0.5).round * 0.5)
                # ;;puts "[1] #{a} => #{scene2.aperture}"
                # clamp to maximum aperture
                scene2.aperture = [scene2.aperture, lens.max_aperture].max
                # ;;puts "[2] #{a} => #{scene2.aperture}"

                #
                # calculate sensitivity
                #

                # start with minimum shutter time
                scene2.shutter = camera.max_shutter
                # round up to the next ISO value
                scene2.sensitivity = SensitivityValue.new_from_v(scene2.sensitivity.to_v.ceil)
                scene2.sensitivity = [scene2.sensitivity, $max_sensitivity].min
                scene2.sensitivity = [scene2.sensitivity, $min_sensitivity].max
                # # force recalculation of shutter
                # scene2.shutter = nil

                scene2.calculate_exposure!

                #
                # compute subject distance difference
                #

                subject_distance_delta = Length.new(scene.subject_distance - scene2.subject_distance)

                #
                # compute angle of view difference
                #

                angle_of_view_delta = Angle.new(scene.angle_of_view - scene2.angle_of_view)

                #
                # validate
                #

                begin
                  validate(scene2, camera, lens, subject_distance_delta, angle_of_view_delta)
                rescue => e
                  failure = e
                end

                puts "  %-15.15s  |  %-19.19s  |  %10s @ %5s @ %8s  |  dist: %6s (%s%6s) |  dof: %6s (-%5s .. +%5s)  |  %s" % [
                  camera.name,
                  lens.name,
                  scene2.aperture,
                  scene2.shutter,
                  scene2.sensitivity,
                  scene2.subject_distance.to_s(:imperial),
                  subject_distance_delta < 0 ? '-' : '+',
                  Length.new(subject_distance_delta.abs).to_s(:imperial),
                  scene2.depth_of_field.to_s(:imperial),
                  scene2.foreground_distance.to_s(:imperial),
                  scene2.background_distance.to_s(:imperial),
                  failure || 'GOOD'
                ]

                successes[camera.name] ||= {}

                if !failure
                  successes[camera.name][lens.name] ||= 0
                  successes[camera.name][lens.name] += 1
                  found = true
                  break
                end

              end

              break if found

            end

            unless found
              successes[camera.name]['FAILED'] ||= 0
              successes[camera.name]['FAILED'] += 1
            end

          end

        end

        ;;pp successes
        # ;;successes.sort_by { |k,v| v }.each { |k,v| puts "%2d: %s" % [v, k] }
      end

    end
  end
end