module PhotoUtils

  # specified in lux or foot-candles
  # incident light

  class IlluminanceValue < Value

    APEX_LABEL = 'Iv'

    def self.new_from_v(v)
      new((2 ** v.to_f) * Constants::N * Constants::C)
    end

    def to_v
      Math.log2(self / Constants::N * Constants::C)
    end

    def string
      '%s lux' % float_string
    end

  end

end