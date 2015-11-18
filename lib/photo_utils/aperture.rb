module PhotoUtils

  class Aperture < Value

    def self.new_from_v(v)
      new(Math.sqrt(2 ** v.to_f))
    end

    def to_v
      Math.log2(self ** 2)
    end

    def to_s(format=:fstop, stop_steps=3)
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
        rounded_f = Aperture.new_from_v((v.to_f * stop_steps).to_i / stop_steps.to_f).prec(1)
        frac = rounded_f.to_f - rounded_f.to_i
        if frac != 0
          "f/#{rounded_f.to_f}"
        else
          "f/#{rounded_f.to_i}"
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