require 'delegate'

module PhotoUtils

  class Value < DelegateClass(Float)

    def self.new_from_v(v)
      raise UnimplementedMethod, "Subclass has not implemented \#new_from_v"
    end

    def initialize(n)
      super(n.to_f)
    end

    def to_v
      raise UnimplementedMethod, "Subclass has not implemented \#to_v"
    end

    def incr
      self.class.new_from_v(self.to_v + 1)
    end

    def decr
      self.class.new_from_v(self.to_v - 1)
    end

    def ==(other)
      self.to_v == self.class.new(other).to_v
    end

    def <=>(other)
      self.to_v <=> self.class.new(other).to_v
    end

  end

end