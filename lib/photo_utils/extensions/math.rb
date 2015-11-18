# coding: utf-8

module Math

  NaN           = 0.0/0
  Infinity      = 1.0/0
  MinusInfinity = -Infinity

  def self.arcdeg(a)
    a * (180 / PI)
  end

end