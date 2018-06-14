module PhotoUtils

  class ApertureValue < Value

    APEX_LABEL = 'Av'

    def self.parse(s)
      case s.to_s.strip
      when %r{^f/([\d\.]+)$}i
        new($1.to_f)
      else
        raise ValueParseError, "Can't parse #{s.inspect} as aperture value"
      end
    end

    def self.new_from_v(v)
      new(Math.sqrt(2 ** v.to_f))
    end

    def to_v
      Math.log2(to_f ** 2)
    end

    def succ
      self.class.new_from_v(to_v + 1)
    end

    def string
      'f/%s' % float_string
    end

    def us_string
      'US %d' % us_stop
    end

    def us_stop
      # Av 8 is equivalent to f/16 and US 16
      steps = to_v.to_i - 8
      us = 16
      if steps < 0
        steps.abs.times { us /= 2 }
      else
        steps.times { us *= 2 }
      end
      us
    end

    def absolute(focal_length)
      focal_length / self
    end

  end

end