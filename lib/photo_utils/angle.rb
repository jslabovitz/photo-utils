# coding: utf-8

require 'delegate'

module PhotoUtils

  class Angle < DelegateClass(Float)

    def initialize(n)
      super(n.to_f)
    end

    def to_s
      "#{self.round}°"
    end

  end

end