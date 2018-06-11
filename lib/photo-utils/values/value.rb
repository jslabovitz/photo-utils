module PhotoUtils

  class Value < DelegateClass(Float)

    class ValueParseError < Error; end

    def self.parse(s)
      case s.to_s.strip
      when /^([\d\.]+)$/
        $1.to_f
      else
        raise ValueParseError, "Can't parse as value: #{s.inspect}"
      end
    end

    def self.new_from_v(v)
      new(2 ** v.to_f)
    end

    def initialize(n)
      n = self.class.parse(n) if n.kind_of?(String)
      super(n.to_f)
    end

    def to_v
      Math.log2(to_f)
    end

    def incr
      self.class.new_from_v(to_v + 1)
    end

    def decr
      self.class.new_from_v(to_v - 1)
    end

    def float_string
      PhotoUtils::format_float(to_f)
    end

    def value_string
      '%s:%s' % [
        self.class::APEX_LABEL,
        PhotoUtils::format_float(to_v),
      ]
    end

    def string
      value_string
    end

    def to_s(format=nil, *args)
      send((format ? "#{format}_" : '') + 'string', *args)
    end

  end

end