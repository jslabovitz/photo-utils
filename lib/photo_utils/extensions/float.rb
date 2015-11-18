class Float

  def prec(x)
    if self == self.round
      self.round
    else
      ("%.*f" % [x, self]).to_f
    end
  end

end