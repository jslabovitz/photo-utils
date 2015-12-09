module PhotoUtils

  class Illuminance < Value

    N = 2 ** Rational(-7, 4)
    C = 224
    NC = N * C

    # amount specified in lux

    def self.new_from_lux(lux)
      new(lux)
    end

    def self.new_from_v(v)
      new((2 ** v.to_f) * NC)
    end

    def to_v
      Math.log2(self / NC)
    end

    def to_lux
      to_f
    end

    def format_lux
      to_lux.format(10) + ' lux'
    end

    def format_value
      "Iv:#{to_v.format(10)}"
    end

    def to_s(format=:lux)
      case format
      when :lux
        format_lux
      when :value
        format_value
      else
        raise "Unknown format: #{format.inspect}"
      end
    end

  end

end