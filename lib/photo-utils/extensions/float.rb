class Float

  def prec(x)
    if self == self.round
      self
    else
      ('%.*f' % [x, self]).to_f
    end
  end

  def format(precision=nil)
    '%.*f' % [
      (precision.nil? || self < precision) ? 1 : 0,
      self,
    ]
  end

end