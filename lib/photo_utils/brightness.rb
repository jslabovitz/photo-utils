# coding: utf-8

module PhotoUtils

  class Brightness < Value

    N = 0.3
    K = 12.5
    
    def self.new_from_v(v)
      new((2 ** v.to_f) * (N * K))
    end
        
    def to_v
      Math.log2(self / (N * K))
    end
    
    def to_s(format=:cdm2)
      case format
      when :cdm2
        "#{round} cd/m2"
      else
        "Bv:#{to_v.prec(1)}"
      end
    end
        
  end

end