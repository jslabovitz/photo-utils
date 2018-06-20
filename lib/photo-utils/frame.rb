module PhotoUtils

  # http://photo.net/medium-format-photography-forum/00QiiV

  class Frame

    attr_reader :width
    attr_reader :height

    def initialize(**params)
      params.each { |k, v| send("#{k}=", v) }
    end

    def width=(w)
      @width = Length.new(w)
    end

    def height=(h)
      @height = Length.new(h)
    end

    def ==(other)
      raise Error, "Not a #{self.class}: #{other.inspect}" unless other.kind_of?(self.class)
      @width == other.width && @height == other.height
    end

    def to_s(format=nil)
      if @height.infinite? && @width.infinite?
        'n/a'
      else
        '%s x %s' % [
          @width.to_s(format),
          @height.to_s(format),
        ]
      end
    end

    def diagonal
      Length.new(
        Math.sqrt(
          (@width ** 2) + (@height ** 2)
        )
      )
    end

  end

end
