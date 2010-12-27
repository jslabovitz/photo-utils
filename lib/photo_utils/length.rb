# coding: utf-8

require 'delegate'

module PhotoUtils

  class Length < DelegateClass(Float)
    
    def self.parse(s)
      if s == '∞'
        n = Math::Infinity
      else
        n = 0
        s = s.dup
        until s.empty?
          s.strip!
          if s.gsub!(/^(\d+(\.\d+)?)\s*/, '')
            x = $1.to_f
            x = if s.gsub!(/^('|ft\b)/, '')
              x.feet
            elsif s.gsub!(/^("|in\b)/, '')
              x.inches
            elsif s.gsub!(/^\s*(m\b)/, '')
              x.meters
            elsif s.gsub!(/^\s*(mm\b)?/, '')
              x.mm
            else
              raise "Can't parse unit: #{s.inspect}"
            end
            n += x
          else
            raise "Can't parse number: #{s.inspect}"
          end
        end
      end
      new(n)
    end
    
    def initialize(n)
      super(n.to_f)
    end
    
    def to_s(format=:metric)
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