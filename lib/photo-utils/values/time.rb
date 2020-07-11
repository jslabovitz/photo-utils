module PhotoUtils

  class TimeValue < Value

    APEX_LABEL = 'Tv'

    def self.parse(s)
      case s.strip
      when %r{^([\d\.]+)/([\d\.]+)s?$}i
        new(Rational($1.to_f, $2.to_f))
      when %r{^([\d\.]+)s?$}i
        new($1.to_f)
      else
        raise ValueParseError, "Can't parse #{s.inspect} as time value"
      end
    end

    def self.new_from(v)
      new(2 ** (-v.to_f))
    end

    def to_v
      -Math.log2(to_f)
    end

    def string
      if self < 1
        '1/%ss' % (1 / to_f).round
      else
        '%ss' % round
      end
    end

  end

end