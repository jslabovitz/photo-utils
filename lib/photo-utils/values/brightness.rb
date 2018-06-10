module PhotoUtils

  # amount specified in cd/m2

  class BrightnessValue < Value

    APEX_LABEL = 'Bv'

    def self.new_from_v(v)
      new((2 ** v.to_f) * (Constants::N * Constants::K))
    end

    def to_v
      Math.log2(to_f / (Constants::N * Constants::K))
    end

    def string
      '%s cd/m2' % float_string
    end

  end

end