module PhotoUtils

  class Compensation < Value

    # amount specified in stops

    def self.new_from_v(v)
      new(v)
    end

    def format_value
      "Cv:%s%s" % [
        (self < 0) ? '-' : '+',
        abs.format(10)
      ]
    end

    def to_s(format=:value)
      case format
      when :value
        format_value
      else
        raise "Unknown format: #{format.inspect}"
      end
    end

  end

end