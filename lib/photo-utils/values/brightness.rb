module PhotoUtils

  # amount specified in cd/m2

  class BrightnessValue < Value

    APEX_LABEL = 'Bv'

    N = 2 ** Rational(-7, 4)
    # K = 11.4
    K = 3.33

    def self.new_from_v(v)
      new((2 ** v.to_f) * (N * K))
    end

    def to_v
      Math.log2(to_f / (N * K))
    end

    def string
      '%s cd/m2' % float_string
    end

  end

end