module PhotoUtils

  class Camera

    attr_reader   :key
    attr_reader   :make
    attr_reader   :model
    attr_reader   :backs
    attr_reader   :sensitivity
    attr_reader   :min_shutter
    attr_reader   :max_shutter
    attr_reader   :lenses

    def initialize(**params)
      @backs = Table.new
      @lenses = Table.new
      format = params.delete(:format)
      frames = params.delete(:frames)
      if format
        add_back(format: format, frames: frames)
      end
      params.each { |k, v| send("#{k}=", v) }
    end

    def key=(key)
      @key = Table.make_key(key)
    end

    def make=(make)
      @make = make.to_s
    end

    def model=(model)
      @model = model.to_s
    end

    def name
      "#{@make} #{@model}"
    end

    def backs=(backs)
      backs.each do |key, back|
        add_back(back.merge(key: key))
      end
    end

    def primary_back
      @backs.first
    end

    def primary_format
      primary_back&.format
    end

    def add_back(back)
      back = case back
      when Back
        back
      when Hash
        Back.new(**back)
      else
        raise "Unknown back spec: #{back.inspect}"
      end
      back.key ||= back.format.key or raise "Can't determine back key"
      @backs << back
    end

    def sensitivity=(s)
      @sensitivity = SensitivityValue.new(s)
    end

    def lenses=(lenses)
      lenses.each do |key, info|
        @lenses << Lens.new(info.merge(key: key))
      end
    end

    def min_shutter=(t)
      @min_shutter = TimeValue.new(t)
    end

    def max_shutter=(t)
      @max_shutter = TimeValue.new(t)
    end

    def median_shutter
      TimeValue.new_from_v(
        ((@max_shutter.to_v + @min_shutter.to_v) / 2).round
      )
    end

    # the lens closest to normal (diagonal of frame)

    def normal_lens(format)
      normal = format.frame.diagonal
      @lenses.sort_by { |l| (normal - l.focal_length).abs }.first
    end

    def to_s
      '%s %s [%s]: formats: %s, shutter: %s~%s' % [
        @make,
        @model,
        @key,
        @backs.to_a.join(', '),
        @max_shutter,
        @min_shutter,
      ]
    end

    def print(io=STDOUT)
      io.puts to_s
      @lenses.each do |lens|
        str = @backs.map do |back|
          format = back.format
          "%s in 35mm: %s @ %s~%s" % [
            format,
            format.focal_length_equivalent(lens.focal_length),
            format.aperture_equivalent(lens.max_aperture),
            format.aperture_equivalent(lens.min_aperture),
          ]
        end.join(', ')
        io.puts "\t" + lens.to_s + " (#{str})"
      end
      io.puts
    end

  end

  Cameras = Table.load(file: CamerasFile, item_class: Camera)

  def Cameras.generic_35mm
    self['g35'] or raise "Can't find generic 35mm"
  end

end