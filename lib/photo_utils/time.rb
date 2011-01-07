# coding: utf-8

module PhotoUtils

  class Time < Value

    def self.new_from_v(v)
      new(2 ** -v.to_f)
    end

    def to_v
      -Math.log2(self.to_f)
    end

    def to_s(format=:seconds)
      case format
      when :seconds
        if self >= 1
          prec(1).to_s + 's'
        else
          '1/' + (1/self).round.to_s
        end
      when :value
        "Tv:#{to_v.prec(1)}"
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