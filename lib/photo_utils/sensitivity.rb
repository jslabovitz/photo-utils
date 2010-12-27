# coding: utf-8

require 'delegate'

module PhotoUtils
  
  class Sensitivity < Value

    def self.new_from_v(v)
      new((2 ** v.to_f) * 3.125)
    end
    
    def to_v
      Math.log2(self / 3.125)
    end
    
    def to_s(format=:iso)
      case format
      when :iso
        "ISO #{round}"
      when :value
        "Sv:#{to_v.prec(1)}"
      end
    end
    
  end

end