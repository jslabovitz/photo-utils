module PhotoUtils

  class Format

    attr_reader   :key
    attr_reader   :frame

    def initialize(params={})
      params.each { |k, v| send("#{k}=", v) }
    end

    def key=(key)
      @key = Table.make_key(key)
    end

    def frame=(frame)
      @frame = case frame
      when Frame
        frame
      when Hash
        Frame.new(**frame)
      else
        raise "Unknown frame object: #{frame.inspect}"
      end
    end

    def to_s
      '%s (%s)' % [
        @key,
        @frame,
      ]
    end

    def focal_length_equivalent(focal_length, other=Formats['135'])
      Length.new(
        focal_length * crop_factor(other)
      )
    end

    def aperture_equivalent(aperture, other=Formats['135'])
      ApertureValue.new(
        aperture * crop_factor(other)
      )
    end

    def crop_factor(other=Formats['135'])
      # http://en.wikipedia.org/wiki/Crop_factor
      other.frame.diagonal / @frame.diagonal
    end

  end

  Formats = Table.new

  # http://photo.net/medium-format-photography-forum/00QiiV
  # http://photo.net/medium-format-photography-forum/00LZPS
  # http://www.largeformatphotography.info/forum/showthread.php?t=2503
  # http://www.kenrockwell.com/tech/format.htm#120
  # http://www.mamiya.com/rb67-pro-sd-accessories-film-magazines,-holders-inserts-roll-film-magazines.html
  # from http://en.wikipedia.org/wiki/Image_sensor_format

  # name(s)  height  width
  Descriptions = %q{
    135             24        36
    FF              24        36
    6x4.5           56        42
    6x6             56        56
    6x7             56        72
    6x8             56        76
    6x9             56        84
    6x10            56        92
    6x12            56        112
    6x17            56        168
    Polaroid 405    3.25in    4.25in
    4x5             97        120
    5x7             127       178
    8x10            203       254
  }.split("\n").map { |l| l.sub(/#.*/, '').strip }.reject(&:empty?).each do |line|
    name, height, width = line.split(/\s{2,}/)
    Formats << Format.new(key: name, frame: { width: width, height: height })
  end

end