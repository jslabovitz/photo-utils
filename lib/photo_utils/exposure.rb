# coding: utf-8

module PhotoUtils

  class Exposure < Value

    def self.new_from_v(v)
      new(v)
    end
    
    def to_v
      self.to_f
    end
    
    def to_s(format=:ev)
      case format
      when :ev
        "EV #{prec(1)}"
      when :value
        "Ev:#{prec(1)}"
      end
    end
    
  end
  
end