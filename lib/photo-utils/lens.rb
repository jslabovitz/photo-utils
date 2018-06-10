module PhotoUtils

  class Lens

    attr_writer   :name
    attr_reader   :focal_length
    attr_reader   :min_aperture
    attr_reader   :max_aperture
    attr_reader   :aperture

    def initialize(params={})
      params.each { |k, v| send("#{k}=", v) }
      @aperture = @max_aperture
    end

    def to_s
      if @name
        "#{@name} (#{@focal_length})"
      else
        @focal_length.to_s
      end
    end

    def name
      @name || @focal_length.to_s
    end

    def focal_length=(f)
      @focal_length = Length.new(f)
    end

    def min_aperture=(a)
      @min_aperture = ApertureValue.new(a)
    end

    def max_aperture=(a)
      @max_aperture = ApertureValue.new(a)
    end

    def aperture=(a)
      @aperture = ApertureValue.new(a)
    end

  end

end