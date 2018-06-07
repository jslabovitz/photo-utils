module PhotoUtils

  class Brightness < Value

    # N = 2 ** Rational(-7, 4)
    N = 0.3
    K = 11.4
    NK = N * K

    # amount specified in cd/m2

    def self.new_from_v(v)
      new((2 ** v.to_f) * NK)
    end

    def self.new_from_cdm2(n)
      new(n)
    end

    def to_v
      Math.log2(to_f / NK)
    end

    def to_cdm2
      to_f
    end

    def format_cdm2
      to_cdm2.format(10) + ' cd/m2'
    end

    def format_value
      "Bv:#{to_v.format}"
    end

    def to_s(format=:cdm2)
      case format
      when :cdm2
        format_cdm2
      when :value
        format_value
      else
        raise "Unknown format: #{format.inspect}"
      end
    end

  end

end