# coding: utf-8

require 'delegate'

module PhotoUtils

  class Length < DelegateClass(Float)
    
    def initialize(x)
      case x
      when Length
        super(x)
      when Numeric
        super(x.to_f)
      when '∞'
        super(Math::Infinity)
      when String
        n = 0
        s = x.dup
        until s.empty?
          if s.gsub!(/^\s*(\d+(\.\d+)?)\s*/, '')
            n2 = $1.to_f
            n2 = if s.gsub!(/^('|ft\b)/, '')
              n2.feet
            elsif s.gsub!(/^("|in\b)/, '')
              n2.inches
            elsif s.gsub!(/^\s*m\b/, '')
              n2.meters
            elsif s.gsub!(/^\s*(mm\b)?/, '')
              n2.mm
            else
              raise "Can't parse unit: #{s.inspect}"
            end
            n += n2
          else
            raise "Can't parse number: #{s.inspect}"
          end
        end
        super(n)
      else
        raise "Can't make length from #{x.class}: #{x.inspect}"
      end
    end
    
    def to_s(format=:metric, precision=nil)
      if self == Math::Infinity
        '∞'
      else 
        case format
        when :imperial
          inches = self * INCHES_PER_METER / 1000
          if inches.floor >= 12
            feet = (inches / 12).floor
            inches %= 12
          else
            feet = 0
          end
          if inches > 0
            inches = inches.ceil
            if inches == 12
              feet += 1
              inches = 0
            end
          end
          (feet > 0 ? "#{feet}'" : '') + (inches > 0 ? "#{inches}\"" : '')
        when :metric
          if self >= 1000
            "#{(self / 1000).prec(2)}m"
          elsif precision
            "#{self.prec(precision)}mm"
          else
            "#{self.round}mm"
          end
        end
      end
    end

    def -(other)
      self.class.new(super(other))
    end

    def abs
      self.class.new(super)
    end

  end
  
end