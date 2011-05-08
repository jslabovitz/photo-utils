# coding: utf-8

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
    
    def initialize(params={})
      params.each do |key, value|
        method("#{key}=").call(value)
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

    def brightness=(n)
      @brightness = n ? Brightness.new(n) : nil
    end

    def aperture
      if @aperture
        @aperture
      elsif @sensitivity && @brightness && @time
        Aperture.new_from_v(sv + bv - tv)
      else
        raise "Need brightness/sensitivity/time to compute aperture"
      end
    end

    def time
      if @time
        @time
      elsif @sensitivity && @brightness && @aperture
        Time.new_from_v(sv + bv - av)
      else
        raise "Need brightness/sensitivity/aperture to compute time"
      end
    end

    def sensitivity
      if @sensitivity
        @sensitivity
      elsif @aperture && @time && @brightness
        Sensitivity.new_from_v(av + tv - bv)
      else
        raise "Need aperture/time/brightness to compute sensitivity"
      end
    end

    def brightness
      if @brightness
        @brightness
      elsif @aperture && @time && @sensitivity
        Brightness.new_from_v(av + tv - sv)
      else
        raise "Need aperture/time/sensitivity to compute brightness"
      end
    end

    def exposure
      if @aperture && @time
        av + tv
      elsif @sensitivity && @brightness
        sv + bv
      else
        raise "Need aperture/time or sensitivity/brightness to compute exposure"
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
      ev - sv - Sensitivity.new(100).to_v
    end
    
    def to_s
      "Ev:#{ev.prec(1)} = #{aperture.to_s(:value)} + #{time.to_s(:value)} = #{sensitivity.to_s(:value)} + #{brightness.to_s(:value)}"
    end
    
    def print(io=STDOUT)
      io.puts "EXPOSURE:"
      io.puts "       brightness: #{brightness} (#{brightness.to_s(:value)})"
      io.puts "      sensitivity: #{sensitivity} (#{sensitivity.to_s(:value)})"
      io.puts "         aperture: #{aperture} (#{aperture.to_s(:value)})"
      io.puts "             time: #{time} (#{time.to_s(:value)})"
      io.puts "         exposure: #{to_s}"
      io.puts
    end
    
  end
  
end