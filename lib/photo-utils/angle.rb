module PhotoUtils

  class Angle < DelegateClass(Float)

    def initialize(n)
      super(n.to_f)
    end

    def to_s
      "#{format}°"
    end

  end

end