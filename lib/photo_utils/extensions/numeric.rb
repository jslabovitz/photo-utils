# coding: utf-8

require 'photo_utils'

INCHES_PER_METER = 39.3700787402

class Numeric
  
  def feet
    PhotoUtils::Length.new(self.to_f * 12 / INCHES_PER_METER * 1000)
  end
  
  def inches
    PhotoUtils::Length.new(self.to_f / INCHES_PER_METER * 1000)
  end
  
  def meters
    PhotoUtils::Length.new(self * 1000)
  end
    
  def mm
    PhotoUtils::Length.new(self)
  end
  
end