module PhotoUtils

  class Angle < DelegateClass(Float)

    def to_s
      '%s°' % round
    end

  end

end