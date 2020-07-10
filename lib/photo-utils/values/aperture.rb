module PhotoUtils

  class ApertureValue < Value

    APEX_LABEL = 'Av'

    def self.parse(s)
      case s
      when String
        case s.strip
        when %r{^(f/)?([\d\.]+)$}i
          new($2.to_f)
        when %r{^US\s+([\d\.]+)$}i
          new_from_us_stop($1.to_f)
        else
          raise ValueParseError, "Can't parse #{s.inspect} as aperture value"
        end
      when Numeric
        new(s)
      else
        raise ValueParseError, "Can't parse #{s.inspect} as aperture value"
      end
    end

    def self.new_from_v(v)
      new(Math.sqrt(2 ** v.to_f))
    end

    def self.new_from_us_stop(us)
      new_from_v(Math.log2(us) + 4)
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
      'US %s' % us_stop.round
    end

    def us_stop
      2 ** (to_v - 4)
    end

  end

end