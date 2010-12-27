# coding: utf-8

class Array
  
  def sum
    inject(nil) { |sum, x| sum ? sum + x : x }
  end

  def mean
    sum / size
  end

end