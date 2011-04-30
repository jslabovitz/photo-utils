# coding: utf-8

module PhotoUtils

  class Scene

    attr_accessor :description
    attr_accessor :frame
    attr_accessor :circle_of_confusion
    attr_accessor :focal_length
    attr_accessor :subject_distance
    attr_accessor :background_distance

    def initialize
      @frame = FORMATS['35']
      @circle_of_confusion = 0.03
      @background_distance = Length.new(Math::Infinity)
    end

    def focal_length=(f)
      @focal_length = Length.new(f)
    end

    def subject_distance=(s)
      @subject_distance = Length.new(s)
    end

    def background_distance=(s)
      @background_distance = Length.new(s)
    end
    
    def aperture_for_depth_of_field(near_limit, far_limit)
      a = ((focal_length ** 2) / circle_of_confusion) * ((far_limit - near_limit) / (2 * near_limit * far_limit))      
      Aperture.new(a)
    end

    def hyperfocal_distance
      # http://en.wikipedia.org/wiki/Hyperfocal_distance
      raise "Need focal length, aperture, and circle of confusion to determine hyperfocal distance" unless focal_length && aperture && circle_of_confusion
      h = ((focal_length ** 2) / (aperture * circle_of_confusion)) + focal_length
      Length.new(h)
    end

    def depth_of_field
      h = hyperfocal_distance
      s = subject_distance
      dof = HashStruct.new
      dof.near = (h * s) / (h + s)
      if s < h
        dof.far = (h * s) / (h - s)
      else
        dof.far = Math::Infinity
      end
      dof.near = Length.new(dof.near)
      dof.far  = Length.new(dof.far)
      dof
    end

    def near_distance_from_subject
      d = subject_distance - depth_of_field.near
      Length.new(d)
    end

    def far_distance_from_subject
      d = (depth_of_field.far == Math::Infinity) ? Math::Infinity : (depth_of_field.far - subject_distance)
      Length.new(d)
    end

    def total_depth_of_field
      d = (depth_of_field.far == Math::Infinity) ? Math::Infinity : (depth_of_field.far - depth_of_field.near)
      Length.new(d)
    end

    def angle_of_view
      raise "Need focal length and frame size to determine angle of view" unless focal_length && frame
      frame.angle_of_view(focal_length)
    end

    def field_of_view(distance)
      raise "Need focal length and frame size to determine field of view" unless focal_length && frame
      frame.field_of_view(focal_length, distance)
    end
    
    def magnification
      # http://en.wikipedia.org/wiki/Depth_of_field#Hyperfocal_magnification
      focal_length.to_f / (subject_distance - focal_length)
    end

    def blur_at_distance(d)
      # http://en.wikipedia.org/wiki/Depth_of_field#Foreground_and_background_blur
      xd = (d - subject_distance).abs
      b = (focal_length * magnification) / aperture
      if d < subject_distance
        b *= xd / (subject_distance - xd)
      else
        b *= xd / (subject_distance + xd)
      end
      b
    end

    def absolute_aperture
      aperture.absolute(focal_length)
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
      Tv = 0 for a time (shutter speed) of one second.
      Av = 0 for an aperture of f/1.
      Sv = 0 for a film speed of ISO 3.125 arithmetic (and hence Sv = 5 for ISO 100).
      Bv = 0 for a scene brightness of 1 foot-lambert.

    calculate time from exposure and aperture
      Tv = Ev - Av

    calculate time from brightness, sensitivity, and aperture
      Tv = (Sv + Bv) - Av

    calculate brightness from Ev and sensitivity
      Bv = Ev - Sv

    calculate Ev from aperture, time, and film speed
      Ev = (Tv + Av) - Sv

=end

    def aperture
      if @aperture
        @aperture
      elsif @sensitivity && @brightness && @time
        Aperture.new_from_v((@sensitivity.to_v + @brightness.to_v) - @time.to_v)
      else
        raise "Need brightness/sensitivity/time to compute aperture"
      end
    end
    
    def aperture=(n)
      @aperture = n ? Aperture.new(n) : nil
    end

    def time
      if @time
        @time
      elsif @sensitivity && @brightness && @aperture
        Time.new_from_v((@sensitivity.to_v + @brightness.to_v) - @aperture.to_v)
      else
        raise "Need brightness/sensitivity/aperture to compute time"
      end
    end
    
    def time=(n)
      @time = n ? Time.new(n) : nil
    end

    def sensitivity
      if @sensitivity
        @sensitivity
      elsif @aperture && @time && @brightness
        Sensitivity.new_from_v(@aperture.to_v + @time.to_v - @brightness.to_v)
      else
        raise "Need aperture/time/brightness to compute sensitivity"
      end
    end

    def sensitivity=(n)
      @sensitivity = n ? Sensitivity.new(n) : nil
    end

    def brightness=(n)
      @brightness = n ? Brightness.new(n) : nil
    end

    def brightness
      if @brightness
        @brightness
      elsif @aperture && @time && @sensitivity
        Brightness.new_from_v(@aperture.to_v + @time.to_v - @sensitivity.to_v)
      else
        raise "Need aperture/time/sensitivity to compute brightness"
      end
    end

    def exposure
      if @aperture && @time
        Exposure.new_from_v(@aperture.to_v + @time.to_v)
      elsif @sensitivity && @brightness
        Exposure.new_from_v(@sensitivity.to_v + @brightness.to_v)
      else
        raise "Need aperture/time or sensitivity/brightness to compute exposure"
      end
    end
    
    def calculate_best_exposure(lens)
      @aperture = @time = nil
      @time = Time.new(1.0/60)
      while aperture < lens.max_aperture
        @aperture = nil
        @time = @time.decr
      end
      while aperture > lens.min_aperture
        @aperture = nil
        @time = @time.incr
      end
    end
    
    def av
      aperture.to_v
    end
    
    def tv
      time.to_v
    end
    
    def sv
      sensitivity.to_v
    end
    
    def bv
      brightness.to_v
    end
    
    def ev
      exposure
    end
    
    def ev100
      Exposure.new(ev - (sv - Sensitivity.new(100).to_v))
    end
    
    def apex
      "#{aperture.to_s(:value)} + #{time.to_s(:value)} = #{sensitivity.to_s(:value)} + #{brightness.to_s(:value)}"
    end
    
    def print_lens_info(io=STDOUT)
      io.puts "     focal length: #{focal_length} (#{
        %w{35 6x4.5 6x6 6x7 5x7}.map { |f| "#{f}: #{frame.focal_length_equivalent(focal_length, FORMATS[f])}" }.join(', ')
      }; crop factor #{frame.crop_factor.prec(2)})"
      io.puts "    angle of view: #{angle_of_view}"
    end
    
    def print_exposure(io=STDOUT)
      io.puts "       brightness: #{brightness} (#{brightness.to_s(:value)})"
      io.puts "      sensitivity: #{sensitivity} (#{sensitivity.to_s(:value)})"
      io.puts "         aperture: #{aperture} (#{aperture.to_s(:value)})"
      io.puts "             time: #{time} (#{time.to_s(:value)})"
      io.puts "         exposure: #{exposure.to_s(:ev, sensitivity)}, #{ev100.to_s(:ev, 100)} (#{apex})"
    end
    
    def print_depth_of_field(io=STDOUT)
      print_lens_info(io)
      fov = 
      io.puts "     subject dist: #{subject_distance.to_s(:imperial)}"
      io.puts "      subject FOV: #{field_of_view(subject_distance).to_s(:imperial)}"
      io.puts "      subject mag: #{magnification}x"
      io.puts "      subject DOF: #{total_depth_of_field.to_s(:imperial)} (-#{near_distance_from_subject.to_s(:imperial)}/+#{far_distance_from_subject.to_s(:imperial)})"
      io.puts "  background dist: #{background_distance.to_s(:imperial)}"
      io.puts "   background FOV: #{field_of_view(background_distance).to_s(:imperial)}"
      io.puts "  background blur: #{blur_at_distance(background_distance)}"
      io.puts "  hyperfocal dist: #{hyperfocal_distance.to_s(:imperial)}"
    end
    
    def print(io=STDOUT)
      print_depth_of_field(io)
      print_exposure(io)
    end

  end

end