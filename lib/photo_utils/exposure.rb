# coding: utf-8

module PhotoUtils

  class Exposure < Value

    def self.new_from_v(v)
      new(v)
    end
    
    def to_v
      self.to_f
    end
    
    def to_s(format=:ev, sensitivity=nil)
      case format
      when :ev
        "Ev#{sensitivity ? sensitivity.to_i : ''} #{prec(1)}"
      when :value
        "Ev:#{prec(1)}"
      else
        raise "Unknown format: #{format.inspect}"
      end
    end
    
  end
  
end