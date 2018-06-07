module PhotoUtils

  class Compensation < Value

    # amount specified in factor

    def self.new_from_factor(f)
      new(f)
    end

    def self.new_from_v(v)
      new(2 ** v)
    end

    def to_factor
      to_f
    end

    def to_v
      Math.log2(to_f)
    end

    def format_factor
      "x%.1f" % to_f.format(10)
    end

    def format_value
      v = to_v
      "Cv:%s%s" % [
        (v < 0) ? '-' : '+',
        v.abs.format(10)
      ]
    end

    def to_s(format=:factor)
      case format
      when :factor
        format_factor
      when :value
        format_value
      else
        raise "Unknown format: #{format.inspect}"
      end
    end

  end

end