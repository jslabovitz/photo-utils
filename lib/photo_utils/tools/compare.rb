require 'photo_utils/tool'

# require 'mini_exiftool'
# require 'pathname2'

module PhotoUtils
  
  class Tools
    
    class Compare < Tool
      
      def run(args)
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
  
        $min_sensitivity = Sensitivity.new(100)
        $max_sensitivity = Sensitivity.new(1600)
        $max_angle_of_view_delta = Angle.new(5)
        $max_subject_distance_delta = 6.feet
  
        base = Pathname.new('/Users/johnl/Pictures/Lightroom Burned Exports')
  
        shots = %q{

          # file                        width DoF   description

          3787022130_ce334b0c20_o.jpg   56"   3'    OCF poem typist: W/A closeup
          3894979751_8ef3683c78_o.jpg   54"   3'    OCF poem typist: medium
          3711708327_917d493f1a_o.jpg   23"   1'    OCF man with hat: torso
          58970238_dfe52a2c77_o.jpg     96"   3'    backlit dancer: medium from medium
          3043470502_9b3406f4dd_o.jpg   81"   3'    winged stripper
          3084813136_180bda6d84_o.jpg   75"   3'    stripper moving away: close from close
          IMG_2664.jpg                  233"  10'   yarddogs dancers: wide from far
          IMG_2672.jpg                  95"   10'   yarddogs horns: medium from far
          IMG_2864.jpg                  49"   2'    sideshow bug eating: close from near
          IMG_2790.jpg                  63"   3'    sideshow ass: medium from near

          060512.031.jpg                233"  6'    Japan: man on street at night
          060512.051.jpg                150'  50'   Japan: Tokyo cityscape
          060512.139.jpg                15'   10'   Japan: man in street
          060514.058.jpg                4'    1'    Japan: bookstore
          060515.081.jpg                7'    4'    Japan: plants at corner
          060519.001.jpg                14"   3"    Japan: eggs
          060520.012.jpg                20'   10'   Japan: haystack
          060524.023.jpg                9'    3'    Japan: plants & rust
          060527.051.jpg                8'    3'    Japan: racoon & bicycle
          060528.003.jpg                18"   6"    Japan: tiny buddhas
    
        }.split(/\n/).map { |line|
          line.gsub!(/^\s+|\s+$/, '')
          line.sub!(/#.*/, '')
          if line.empty?
            nil
          else
            file, width, dof, type = line.split(/\s+/, 4)
              dof = Length.new(dof)
            width = Length.new(width)
            HashStruct.new(
              :type => type,
              :file => file,
              :subject_width => width,
              :desired_dof => dof)
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

          # if scene.angle_of_view - scene.angle_of_view > 5
          #   raise "angle of view too wide (#{scene2.angle_of_view} > #{scene.angle_of_view})"
          #   next
          # end

          #
          # validate shutter
          #

          if scene.time > camera.max_shutter
            raise "shutter too slow (#{scene.time} < #{camera.max_shutter})"
          end
    
        end
  
        successes = {}
  
        shots.each do |shot|

          img = MiniExiftool.new(base + shot.file, :numerical => true, :timestamps => DateTime)
    
          scene = Scene.new
    
          model = img['Model']
          scene.format = Format[model] or raise "Can't determine frame for model #{model.inspect} (#{shot.file})"
    
          scene.description = "#{shot[:type]} [#{shot[:seq]}]"
          scene.aperture = img['Aperture']
          if img['ISO'].kind_of?(Numeric)
            scene.sensitivity = img['ISO']
          else # "0 800"
            scene.sensitivity = img['ISO'].split(' ').last.to_f
          end
          scene.time = img['ExposureTime']
          scene.focal_length = img['FocalLength']
    
          exp_comp = img['ExposureCompensation'].to_f
          if exp_comp != 0
            scene.sensitivity = Sensitivity.new_from_v(scene.sensitivity.to_v + exp_comp)
          end
    
          # d = w * f / s
          scene.subject_distance = Length.new(shot.subject_width * (scene.focal_length / scene.format.width))
    
          puts
          puts "--- #{scene.description}"
          puts
    
          scene.print_exposure
          scene.print_depth_of_field
          puts
    
          # now compute equivalent scene for each camera
    
          cameras.each do |camera|
      
            scene2 = Scene.new
            scene2.format = camera.format or raise "Unknown format: #{camera.format.inspect}"
            scene2.aperture = scene.aperture
            scene2.brightness = scene.brightness
            # scene2.sensitivity = 400
      
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
        
                scene2.subject_distance = 1 / ((scene2.frame.width / scene2.focal_length) / shot.subject_width)
        
                #
                # calculate depth of field
                #
          
                near_limit = scene2.subject_distance - (shot.desired_dof / 2)
                far_limit  = scene2.subject_distance + (shot.desired_dof / 2)
                scene2.aperture = scene2.aperture_for_depth_of_field(near_limit, far_limit)
          
                #
                # adjust aperture
                #
          
                # ;;a = scene2.aperture
                # round aperture to closest 1/2 stop
                scene2.aperture = Aperture.new_from_v((scene2.aperture.to_v / 0.5).round * 0.5)
                # ;;puts "[1] #{a} => #{scene2.aperture}"
                # clamp to maximum aperture
                scene2.aperture = [scene2.aperture, lens.max_aperture].max
                # ;;puts "[2] #{a} => #{scene2.aperture}"
          
                #
                # calculate sensitivity
                #
          
                # start with minimum shutter time
                scene2.time = camera.max_shutter
                # round up to the next ISO value
                scene2.sensitivity = Sensitivity.new_from_v(scene2.sensitivity.to_v.ceil)
                scene2.sensitivity = [scene2.sensitivity, $max_sensitivity].min
                scene2.sensitivity = [scene2.sensitivity, $min_sensitivity].max
                # # force recalculation of shutter
                # scene2.time = nil
          
                #
                # compute subject distance difference
                #
          
                subject_distance_delta = scene.subject_distance - scene2.subject_distance
          
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
                  scene2.time,
                  scene2.sensitivity,
                  scene2.subject_distance.to_s(:imperial),
                  subject_distance_delta < 0 ? '-' : '+',
                  subject_distance_delta.abs.to_s(:imperial),
                  scene2.total_depth_of_field.to_s(:imperial),
                  scene2.near_distance_from_subject.to_s(:imperial),
                  scene2.far_distance_from_subject.to_s(:imperial),
                  failure || 'GOOD'
                ] if options[:verbose] || !failure
          
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