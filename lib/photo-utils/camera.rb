module PhotoUtils

  class Camera

    DefaultCamerasFile = Path.new(__FILE__).dirname / '../../cameras.yaml'
    UserCamerasFile = Path.new('~/.cameras.yaml').expand_path

    @@cameras = {}

    def self.read_cameras
      if @@cameras.empty?
        read_cameras_file(DefaultCamerasFile)
        read_cameras_file(UserCamerasFile) if UserCamerasFile.exist?
      end
    end

    def self.cameras
      read_cameras
      @@cameras.values
    end

    def self.read_cameras_file(file)
      begin
        yaml = YAML.load(file.read, symbolize_names: true)
      rescue Psych::SyntaxError => e
        raise Error, "Syntax error in #{file.to_s.inspect}: #{e}"
      end
      yaml.each do |camera_yaml|
        camera = Camera.new(**camera_yaml)
        @@cameras[camera.name] = camera
      end
    end

    def self.find(name)
      read_cameras
      @@cameras[name]
    end

    def self.generic_35mm
      find('Generic 35mm') or raise "No generic 35mm camera defined"
    end

    attr_accessor :name
    attr_reader   :formats
    attr_reader   :sensitivity
    attr_reader   :min_shutter
    attr_reader   :max_shutter
    attr_reader   :lenses

    def initialize(**params)
      if params[:format]
        params[:formats] = [params.delete(:format)]
      end
      params.each { |k, v| send("#{k}=", v) }
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
      '%s: formats: %s, shutter: %s~%s' % [
        @name,
        @formats.join(', '),
        @max_shutter,
        @min_shutter,
      ]
    end

    def print(io=STDOUT)
      io.puts to_s
      @lenses.each do |lens|
        str = @formats.map do |format|
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

end