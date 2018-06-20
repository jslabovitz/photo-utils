module PhotoUtils

  class Scene

    attr_accessor :description
    attr_reader   :subject_distance
    attr_reader   :foreground_distance
    attr_reader   :background_distance
    attr_accessor :sensor_frame
    attr_reader   :focal_length
    attr_reader   :aperture
    attr_reader   :shutter
    attr_reader   :sensitivity
    attr_reader   :brightness
    attr_reader   :exposure

    def initialize(camera: nil, lens: nil, **params)
      if camera
        format = camera.formats.first
        lens ||= camera.normal_lens(format)
        params[:sensor_frame] ||= format.frame
        params[:focal_length] ||= lens.focal_length
        params[:shutter] ||= camera.median_shutter
        params[:aperture] ||= lens.median_aperture
        params[:sensitivity] ||= camera.sensitivity
      end
      params.each { |k, v| send("#{k}=", v) }
    end

    def brightness=(b)
      @brightness = BrightnessValue.new(b)
    end

    def subject_distance=(s)
      @subject_distance = Length.new(s)
    end

    def foreground_distance=(s)
      @foreground_distance = Length.new(s)
    end

    def background_distance=(s)
      @background_distance = Length.new(s)
    end

    def focal_length=(f)
      @focal_length = Length.new(f)
    end

    def aperture=(a)
      @aperture = ApertureValue.new(a)
    end

    def shutter=(t)
      @shutter = TimeValue.new(t)
    end

    def sensitivity=(s)
      @sensitivity = SensitivityValue.new(s)
    end

    def exposure=(e)
      @exposure = ExposureValue.new(e)
    end

    def calculate_aperture_for_depth_of_field!
      raise "Must define foreground_distance and background_distance to compute aperture" \
        unless @foreground_distance && @background_distance
      @aperture = ApertureValue.new(
        ((@focal_length ** 2) / circle_of_confusion) *
        (depth_of_field / (2 * @foreground_distance * @background_distance))
      )
    end

    def hyperfocal_distance
      # http://en.wikipedia.org/wiki/Hyperfocal_distance
      Length.new(
        (
          (@focal_length ** 2) / (@aperture * circle_of_confusion)
        ) + @focal_length
      )
    end

    def calculate_depth_of_field!
      h = hyperfocal_distance
      @foreground_distance = Length.new((h * @subject_distance) / (h + @subject_distance))
      if @subject_distance < h
        @background_distance = Length.new((h * @subject_distance) / (h - @subject_distance))
      else
        @background_distance = Length.new(Float::INFINITY)
      end
    end

    def depth_of_field
      raise "Must define foreground_distance and background_distance to compute depth of field" \
        unless @foreground_distance && @background_distance
      Length.new(
        @background_distance - @foreground_distance
      )
    end

    def magnification
      # http://en.wikipedia.org/wiki/Depth_of_field#Hyperfocal_magnification
      @focal_length / (@subject_distance - @focal_length)
    end

    # AKA bellows factor

    def working_aperture
      # http://en.wikipedia.org/wiki/F-number#Working_f-number
      ApertureValue.new((1 - magnification) * @aperture)
    end

    # diameter of blur disk

    def blur_at_distance(distance)
      # http://en.wikipedia.org/wiki/Depth_of_field#Foreground_and_background_blur
      depth = (distance - @subject_distance).abs
      Length.new(
        (
          (
            @focal_length * magnification
          ) / @aperture
        ) * (
          depth / (
            @subject_distance + (
              distance < @subject_distance ? -depth : depth
            )
          )
        )
      )
    end

    def in_focus?(distance)
      blur_at_distance(distance) <= circle_of_confusion
    end

    def angle_of_view
      # http://imaginatorium.org/stuff/angle.htm
      # http://en.wikipedia.org/wiki/Angle_of_view
      arc = 2 * Math.atan(@sensor_frame.diagonal / (2 * @focal_length))
      degrees = arc * (180 / Math::PI)
      Angle.new(degrees)
    end

    def field_of_view(distance)
      # http://en.wikipedia.org/wiki/Field_of_view
      Frame.new(
        width:  distance * (@sensor_frame.width  / @focal_length),
        height: distance * (@sensor_frame.height / @focal_length))
    end

    def distance_for_field_of_view(fov)
      d_w = fov.width  / @sensor_frame.width  * @focal_length
      d_h = fov.height / @sensor_frame.height * @focal_length
      [d_w, d_h].max
    end

    def circle_of_confusion
      # http://en.wikipedia.org/wiki/Circle_of_confusion
      @sensor_frame.diagonal / 1500
    end

    #FIXME: unused

    def stepped_exposures(steps: 7, increment: 0.3, &block)
      n = increment * (steps / 2)
      (-n..n).step(increment).map do |adjustment|
        dup.tap { |e| yield(e) }
      end
    end

=begin

    http://doug.kerr.home.att.net/pumpkin/APEX.pdf
    http://en.wikipedia.org/wiki/APEX_system
    http://en.wikipedia.org/wiki/Exposure_value
    http://en.wikipedia.org/wiki/Light_meter#Exposure_meter_calibration

    basic APEX formula:
      Ev = Tv + Av = Sv + Bv

    logarithmic to linear equations:
      2^Av = N^2 (N is f-Number)
      2^Tv = 1/T (T in seconds)
      2^Sv = S/π (S is ASA film speed, now ISO)
      2^Bv = Bl (Bl in foot-lamberts) = B/π (B in candles per square foot)

    base values:
      Tv = 0 for a time (shutter speed) of one second
      Av = 0 for an aperture of f/1
      Sv = 0 for a film speed of ISO 3.125 arithmetic (and hence Sv = 5 for ISO 100)
      Bv = 0 for a scene brightness of 1 foot-lambert

    calculate time from exposure and aperture
      Tv = Ev - Av

    calculate time from brightness, sensitivity, and aperture
      Tv = (Sv + Bv) - Av

    calculate brightness from Ev and sensitivity
      Bv = Ev - Sv

    calculate Ev from aperture, time, and film speed
      Ev = (Tv + Av) - Sv

=end

    def calculate_exposure!
      ev = if @aperture && @shutter
        @aperture.to_v + @shutter.to_v
      elsif @sensitivity && @brightness
        @sensitivity.to_v + @brightness.to_v
      else
        raise "Must set either aperture/shutter or sensitivity/brightness"
      end
      @shutter ||= TimeValue.new_from_v(ev - @aperture.to_v)
      @aperture ||= ApertureValue.new_from_v(ev - @shutter.to_v)
      @sensitivity ||= SensitivityValue.new_from_v(ev - @brightness.to_v)
      @brightness ||= BrightnessValue.new_from_v(ev - @sensitivity.to_v)
      @exposure = ExposureValue.new_from_v(ev)
    end

    def exposure_string
      '%s = %s + %s = %s + %s' % [
        @exposure.to_s(:value),
        @aperture.to_s(:value),
        @shutter.to_s(:value),
        @sensitivity.to_s(:value),
        @brightness.to_s(:value),
      ]
    end

    def field_string(label, value)
      '  %15s: %s' % [label, value]
    end

    def distance_string(distance)
      case distance
      when nil
        '--'
      when Length
        '%s (%s)' % [
          distance ? distance.to_s(:imperial) : '--',
          distance ? field_of_view(distance).to_s(:imperial) : '--',
        ]
      else
        raise "Value is not a length: #{distance.inspect}"
      end
    end

    def print(io=STDOUT)
      io.puts "SCENE:"
      {
        'description' => @description,
        'sensor frame' => @sensor_frame,
        'focal length' => @focal_length,
        'aperture' => @aperture,
        'shutter' => @shutter,
        'sensitivity' => @sensitivity,
        'brightness' => @brightness,
        'exposure' => exposure_string,
        'foreground' => distance_string(@foreground_distance),
        'subject' => distance_string(@subject_distance),
        'background' => distance_string(@background_distance),
        'hyperfocal' => distance_string(hyperfocal_distance),
        'depth of field' => depth_of_field.to_s(:imperial),
        'magnification' => magnification.round(2),
      }.each do |label, value|
        io.puts field_string(label, value)
      end
    end

  end

end