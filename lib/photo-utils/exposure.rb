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

    attr_accessor :time
    attr_accessor :aperture
    attr_accessor :sensitivity
    attr_accessor :brightness
    attr_accessor :exposure

    def self.calculate(params={})
      new(params).tap do |exp|
        exp.calculate!
      end
    end

    def initialize(params={})
      params.each do |key, value|
        send("#{key}=", value)
      end
    end

    def calculate!
      ev = if @aperture && @time
        @aperture.to_v + @time.to_v
      elsif @sensitivity && @brightness
        @sensitivity.to_v + @brightness.to_v
      else
        raise "Must set either aperture/time or sensitivity/brightness"
      end
      @time ||= TimeValue.new_from_v(ev - @aperture.to_v)
      @aperture ||= ApertureValue.new_from_v(ev - @time.to_v)
      @sensitivity ||= SensitivityValue.new_from_v(ev - @brightness.to_v)
      @brightness ||= BrightnessValue.new_from_v(ev - @sensitivity.to_v)
      @exposure = ExposureValue.new_from_v(ev)
    end

    #FIXME: unused

    def stepped_exposures(steps: 7, increment: 0.3, &block)
      n = increment * (steps / 2)
      (-n..n).step(increment).map do |adjustment|
        dup.tap { |e| yield(e) }
      end
    end

    def to_s
      "%s = %s (%s) + %s (%s) = %s (%s) + %s (%s)" % [
        @exposure.to_s(:value),
        @aperture,
        @aperture.to_s(:value),
        @time,
        @time.to_s(:value),
        @sensitivity,
        @sensitivity.to_s(:value),
        @brightness,
        @brightness.to_s(:value),
      ]
    end

  end

end