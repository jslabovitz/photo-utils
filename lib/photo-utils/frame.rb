module PhotoUtils

  # http://photo.net/medium-format-photography-forum/00QiiV

  class Frame

    attr_accessor :height
    attr_accessor :width

    def initialize(height, width)
      # correct swapped values
      width, height = height, width if height < width
      @height = Length.new(height)
      @width  = Length.new(width)
    end

    def inspect
      "<#{self.class} height=#{@height.inspect} width=#{@width.inspect}>"
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

  end

end
