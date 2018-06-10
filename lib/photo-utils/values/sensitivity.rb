module PhotoUtils

  class SensitivityValue < Value

    APEX_LABEL = 'Sv'

    C = 3.125

    def self.new_from_v(v)
      new(C * (2 ** v.to_f))
    end

    def to_v
      Math.log2(self / C)
    end

    def string
      'ISO %s' % float_string
    end

  end

end