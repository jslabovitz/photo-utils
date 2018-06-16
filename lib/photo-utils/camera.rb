module PhotoUtils

  class Camera

    DefaultCamerasFile = Path.new(__FILE__).dirname / '../../cameras.yaml'
    UserCamerasFile = Path.new('~/.cameras.yaml').expand_path

    @@cameras = []

    def self.read_cameras
      read_cameras_file(DefaultCamerasFile)
      read_cameras_file(UserCamerasFile) if UserCamerasFile.exist?
    end

    def self.cameras
      @@cameras
    end

    def self.read_cameras_file(file)
      begin
        yaml = YAML.load(file.read, symbolize_names: true)
      rescue Psych::SyntaxError => e
        raise Error, "Syntax error in #{file.to_s.inspect}: #{e}"
      end
      yaml.each do |camera_yaml|
        @@cameras << Camera.new(camera_yaml)
      end
    end

    def self.find(params)
      if (sel = params[:name])
        @@cameras.find { |c| sel === c.name }
      else
        raise "Don't know how to search for camera with params: #{params.inspect}"
      end
    end

    def self.[](name)
      find(name: name)
    end

    attr_accessor :name
    attr_reader   :formats
    attr_reader   :format
    attr_reader   :sensitivity
    attr_reader   :min_shutter
    attr_reader   :max_shutter
    attr_reader   :shutter
    attr_reader   :lenses
    attr_accessor :lens

    def initialize(params={})
      if params[:format]
        params[:formats] = [params.delete(:format)]
      end
      params.each { |k, v| send("#{k}=", v) }
      set_defaults!
    end

    def formats=(formats)
      @formats = formats.map do |format|
        Format.find(format.to_s) or raise "Unknown format #{format.inspect} for camera #{name.inspect}"
      end
    end

    def sensitivity=(s)
      @sensitivity = SensitivityValue.new(s)
    end

    def lenses=(lenses)
      @lenses = lenses.map { |lens| Lens.new(lens) }.sort_by(&:focal_length)
    end

    def min_shutter=(t)
      @min_shutter = TimeValue.new(t)
    end

    def max_shutter=(t)
      @max_shutter = TimeValue.new(t)
    end

    def shutter=(t)
      @shutter = TimeValue.new(t)
    end

    def set_defaults!
      @format = @formats.first
      @lens = normal_lens(@format)
      @shutter = @max_shutter
      @sensitivity = SensitivityValue.new(100)  #FIXME: get from Medium
    end

    # the lens closest to normal (diagonal of frame)

    def normal_lens(format)
      normal = format.frame.diagonal
      @lenses.sort_by { |l| (normal - l.focal_length).abs }.first
    end

    def angle_of_view
      @format.angle_of_view(@lens.focal_length)
    end

    def field_of_view(distance)
      @format.field_of_view(@lens.focal_length, distance)
    end

    def aperture
      @lens.aperture
    end

    def focal_length
      @lens.focal_length
    end

    def focal_length_equivalent(format)
      @format.focal_length_equivalent(@lens.focal_length, format)
    end

    def to_s
      '%s: format: %s (%s), shutter: %s (%s~%s), angle of view: %s' % [
        @name,
        @format,
        @formats.join(', '),
        @shutter,
        @max_shutter,
        @min_shutter,
        angle_of_view,
      ]
    end

    def print(io=STDOUT)
      io.puts to_s
      @lenses.each do |lens|
        io.puts "\t%s %s" % [
          (lens == @lens) ? '*' : ' ',
          lens,
        ]
      end
    end

  end

end