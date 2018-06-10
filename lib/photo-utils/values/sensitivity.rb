module PhotoUtils

  class SensitivityValue < Value

    APEX_LABEL = 'Sv'

    def self.new_from_v(v)
      new(Constants::ISO_BASE * (2 ** v.to_f))
    end

    def to_v
      Math.log2(self / Constants::ISO_BASE)
    end

    def string
      'ISO %s' % float_string
    end

  end

end