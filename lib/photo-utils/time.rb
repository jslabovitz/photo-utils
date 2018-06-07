module PhotoUtils

  class Time < Value

    def self.new_from_seconds(s)
      new(s)
    end

    def self.new_from_v(v)
      new(2 ** -v.to_f)
    end

    def to_v
      -Math.log2(self.to_f)
    end

    def to_seconds
      to_f
    end

    def format_seconds
      if (seconds = to_seconds) < 1
        '1/' + (1/self).format(1)
      else
        seconds.format
      end + 's'
    end

    def format_value
      "Tv:#{to_v.format(10)}"
    end

    def to_s(format=:seconds)
      case format
      when :seconds
        format_seconds
      when :value
        format_value
      else
        raise "Unknown format: #{format.inspect}"
      end
    end

    # http://www.apug.org/forums/forum37/22334-fuji-neopan-400-reciprocity-failure-data.html

    def reciprocity
      tc = self + (0.3 * (self ** 1.62))
      Time.new(tc)
    end

  end

end