# coding: utf-8

module PhotoUtils

  class Sensitivity < Value

    def self.new_from_v(v)
      new((2 ** v.to_f) / 0.32)
    end

    def to_v
      Math.log2(self * 0.32)
    end

    def to_s(format=:iso)
      case format
      when :iso
        "ISO #{round}"
      when :value
        "Sv:#{to_v.prec(1)}"
      else
        raise "Unknown format: #{format.inspect}"
      end
    end

  end

end