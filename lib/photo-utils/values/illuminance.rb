module PhotoUtils

  # amount specified in lux

  class IlluminanceValue < Value

    APEX_LABEL = 'Iv'

    N = 2 ** Rational(-7, 4)
    C = 224
    NC = N * C

    def self.new_from_v(v)
      new((2 ** v.to_f) * NC)
    end

    def to_v
      Math.log2(self / NC)
    end

    def string
      '%s lux' % float_string
    end

  end

end