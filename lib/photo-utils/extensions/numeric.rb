INCHES_PER_METER = 39.3700787402

class Numeric

  def feet
    PhotoUtils::Length.new(self * 12.0 / INCHES_PER_METER * 1000.0)
  end

  def inches
    PhotoUtils::Length.new(self / INCHES_PER_METER * 1000.0)
  end

  def meters
    PhotoUtils::Length.new(self * 1000.0)
  end

  def mm
    PhotoUtils::Length.new(self)
  end

end