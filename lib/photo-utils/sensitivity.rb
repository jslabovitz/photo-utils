module PhotoUtils

  class Sensitivity < Value

    C = 3.125

    def self.new_from_iso(n)
      new(n)
    end

    def self.new_from_v(v)
      new(C * (2 ** v.to_f))
    end

    def to_v
      Math.log2(self / C)
    end

    def to_iso
      to_f
    end

    def format_iso
      'ISO ' + to_iso.format(10)
    end

    def format_value
      "Sv:#{to_v.format}"
    end

    def to_s(format=:iso)
      case format
      when :iso
        format_iso
      when :value
        format_value
      else
        raise "Unknown format: #{format.inspect}"
      end
    end

  end

end