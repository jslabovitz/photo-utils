# coding: utf-8

module PhotoUtils

  # http://photo.net/medium-format-photography-forum/00QiiV
  
  class Frame
    
    attr_accessor :height
    attr_accessor :width
    
    def initialize(height, width)
      @height = Length.new(height)
      @width  = Length.new(width)
    end
    
    def to_s(format=:metric)
      if @height == Math::Infinity && @width == Math::Infinity
        "n/a"
      else
        "#{@height.to_s(format)} x #{@width.to_s(format)}"
      end
    end
  
    def diagonal
      d = Math.sqrt((@height ** 2) + (@width ** 2))
      Length.new(d)
    end
  
    def focal_length_equivalent(focal_length, other=FORMATS['35'])
      f = focal_length * crop_factor(other)
      Length.new(f)
    end
    
    def crop_factor(reference=FORMATS['35'])
      # http://en.wikipedia.org/wiki/Crop_factor
      reference.diagonal / diagonal
    end
    
    def angle_of_view(focal_length)
      # http://imaginatorium.org/stuff/angle.htm
      # http://en.wikipedia.org/wiki/Angle_of_view
      a = Math.arcdeg(2 * Math.atan(diagonal / (2 * focal_length)))
      Angle.new(a)
    end
    
    def field_of_view(focal_length, subject_distance)
      # http://en.wikipedia.org/wiki/Field_of_view
      self.class.new(
        subject_distance * (height / focal_length),
        subject_distance * (width  / focal_length))
    end
  
  end

end