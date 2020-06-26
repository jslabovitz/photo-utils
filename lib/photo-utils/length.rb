module PhotoUtils

  class Length < DelegateClass(Float)

    def self.parse(s)
      s = s.dup
      if s == '∞'
        new(Float::INFINITY)
      else
        n = 0
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
        new(n)
      end
    end

    def initialize(obj)
      case obj
      when Length, Numeric
        super(obj.to_f)
      when String
        super(self.class.parse(obj))
      else
        raise "Can't make length from #{obj.class}: #{obj.inspect}"
      end
    end

    # def +(other)
    #   self.class.new(super)
    # end

    # def -(other)
    #   self.class.new(super)
    # end

    # def /(other)
    #   self.class.new(super)
    # end

    # def *(other)
    #   self.class.new(super)
    # end

    def imperial_string
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
    end

    def metric_string
      if self >= 1000
        '%sm' % (self / 1000).format
      else
        '%dmm' % self
      end
    end

    def to_s(format=nil)
      if infinite?
        '∞'
      else
        case format
        when nil
          metric_string
        when :imperial
          imperial_string
        end
      end
    end

  end

end