# coding: utf-8

module PhotoUtils

  class Aperture < Value
    
    def self.new_from_v(v)
      new(Math.sqrt(2 ** v.to_f))
    end

    def to_v
      Math.log2(self ** 2)
    end
    
    def to_s(format=:fstop)
      v = to_v
      case format
      when :us
        # Av 8 is equivalent to f/16 and US 16
        steps = v.to_i - 8
        us = 16
        if steps < 0
          steps.abs.times { us /= 2 }
        else
          steps.times { us *= 2 }
        end
        "US #{us}"
      when :fstop
        frac = v - v.to_i
        if frac < 0.25 || frac > 0.75
          "f/#{Aperture.new_from_v(v.round).prec(1)}"
        else
          "f/#{Aperture.new_from_v(v.floor).prec(1)}~#{Aperture.new_from_v(v.ceil).prec(1)}"
        end
      when :value
        "Av:#{v.prec(1)}"
      else
        raise "Unknown format: #{format.inspect}"
      end
    end
    
    def absolute(focal_length)
      focal_length / self
    end
        
  end

end