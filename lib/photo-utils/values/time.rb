module PhotoUtils

  class TimeValue < Value

    APEX_LABEL = 'Tv'

    def self.new_from(v)
      new(2 ** (-v.to_f))
    end

    def to_v
      -Math.log2(to_f)
    end

    def string
      if self < 1
        '1/%ss' % (1 / to_f).round
      else
        '%ss' % round
      end
    end

  end

end