module PhotoUtils

  class Lens

    attr_writer   :name
    attr_reader   :focal_length
    attr_reader   :min_aperture
    attr_reader   :max_aperture
    attr_reader   :aperture

    def initialize(params={})
      @name = nil
      params.each { |k, v| send("#{k}=", v) }
      set_defaults!
    end

    def to_s
      '%s: focal length: %s, aperture: %s (%s~%s)' % [
        name,
        @focal_length,
        @aperture,
        @max_aperture,
        @min_aperture,
      ]
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

    def set_defaults!
      @aperture = median_aperture
    end

    def median_aperture
      ApertureValue.new_from_v(
        ((@max_aperture.to_v + @min_aperture.to_v) / 2).round
      )
    end

    def absolute_aperture
      @focal_length / @aperture
    end

  end

end