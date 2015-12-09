module PhotoUtils

  class Exposure

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

    attr_accessor :aperture
    attr_accessor :time
    attr_accessor :sensitivity
    attr_accessor :light
    attr_accessor :compensation

    def initialize(params={})
      params.each do |key, value|
        send("#{key}=", value)
      end
    end

    def aperture=(n)
      @aperture = n ? Aperture.new(n) : nil
    end

    def time=(n)
      @time = n ? Time.new(n) : nil
    end

    def sensitivity=(n)
      @sensitivity = n ? Sensitivity.new(n) : nil
    end

    def light=(n)
      @light = case n
      when Brightness, Illuminance
        n
      when Numeric
        Brightness.new(n)
      when nil
        nil
      else
        raise
      end
    end

    def compensation=(n)
      @compensation = n ? Compensation.new_from_v(n) : nil
    end

    def aperture
      if @aperture
        @aperture
      elsif @sensitivity && @light && @time
        Aperture.new_from_v(sv + lv - tv + cv)
      else
        raise "Need sensitivity/light/time to compute aperture"
      end
    end

    def time
      if @time
        @time
      elsif @sensitivity && @light && @aperture
        Time.new_from_v(sv + lv - av + cv)
      else
        raise "Need sensitivity/light/aperture to compute time"
      end
    end

    def sensitivity
      if @sensitivity
        @sensitivity
      elsif @aperture && @time && @light
        Sensitivity.new_from_v(av + tv - bv + cv)
      else
        raise "Need aperture/time/light to compute sensitivity"
      end
    end

    def brightness
      if @light
        Brightness.new_from_v(lv)
      elsif @aperture && @time && @sensitivity
        Brightness.new_from_v(av + tv - sv + cv)
      else
        raise "Need aperture/time/sensitivity to compute brightness"
      end
    end

    def illuminance
      if @light
        Illuminance.new_from_v(lv)
      elsif @aperture && @time && @sensitivity
        Illuminance.new_from_v(av + tv - sv + cv)
      else
        raise "Need aperture/time/sensitivity to compute illuminance"
      end
    end

    def exposure
      if @aperture && @time
        av + tv
      elsif @sensitivity && @light
        sv + lv + cv
      else
        raise "Need aperture/time or sensitivity/light to compute exposure"
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

    def iv
      illuminance.to_v
    end

    def lv
      light.to_v
    end

    def cv
      @compensation ? @compensation.to_f : 0
    end

    def ev
      exposure
    end

    def ev100
      ev - sv - Sensitivity.new(100).to_v
    end

    def stepped_exposures(steps=7, increment=0.3)
      n = increment * (steps / 2)
      (-n..n).step(increment).map do |adjustment|
        new_exposure = dup
        new_exposure.compensation = (@compensation ? @compensation : 0) + adjustment
        new_exposure
      end
    end

    def to_s
      "%s = %s + %s = %s + %s" % [
        "Ev:#{ev.format(10)}",
        aperture.format_value,
        time.format_value,
        sensitivity.format_value,
        light.format_value,
      ]
    end

    def print(io=STDOUT)
      io.puts "EXPOSURE:"
      io.puts "            light: #{light} (#{light.format_value})"
      io.puts "      sensitivity: #{sensitivity} (#{sensitivity.format_value})"
      io.puts "         aperture: #{aperture} (#{aperture.format_value})"
      io.puts "             time: #{time} (#{time.format_value})"
      io.puts "     compensation: #{@compensation ? compensation.format_value : '--'}"
      io.puts "         exposure: #{to_s}"
      io.puts
    end

  end

end