module PhotoUtils

  class Lens

    attr_reader   :key
    attr_reader   :make
    attr_reader   :model
    attr_reader   :focal_length
    attr_reader   :min_aperture
    attr_reader   :max_aperture

    def initialize(params={})
      params.each { |k, v| send("#{k}=", v) }
    end

    def key=(key)
      @key = key.to_s.downcase
    end

    def make=(make)
      @make = make.to_s
    end

    def model=(model)
      @model = model.to_s
    end

    def to_s
      '%s %s [%s]: focal length: %s, aperture: %s~%s' % [
        @make,
        @model,
        @key,
        @focal_length,
        @max_aperture,
        @min_aperture,
      ]
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
      a = ApertureValue.new(a)
      raise Error, "Aperture out of range of lens: #{a} (#{aperture_range})" unless aperture_range.include?(a)
      @aperture = a
    end

    def aperture_range
      @max_aperture .. @min_aperture
    end

    def median_aperture
      ApertureValue.new_from_v(
        ((@max_aperture.to_v + @min_aperture.to_v) / 2).round
      )
    end

  end

end