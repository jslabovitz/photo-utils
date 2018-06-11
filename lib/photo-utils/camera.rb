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
    attr_accessor :format
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
      @format = @formats.first
      @lens = normal_lens
      @shutter = @max_shutter
    end

    def formats=(formats)
      @formats = formats.map do |format|
        Format.find(format.to_s) or raise "Unknown format #{format.inspect} for camera #{name.inspect}"
      end
    end

    def lenses=(lenses)
      @lenses = lenses.map do |lens|
        Lens.new(lens)
      end
    end

    def min_shutter=(t)
      @min_shutter = t ? TimeValue.new(t) : nil
    end

    def max_shutter=(t)
      @max_shutter = t ? TimeValue.new(t) : nil
    end

    def shutter=(t)
      @shutter = t ? TimeValue.new(t) : nil
    end

    # the lens closest to normal (diagonal of frame)

    def normal_lens
      normal = @format.frame.diagonal
      @lenses.sort_by { |l| (normal - l.focal_length).abs }.first
    end

    def angle_of_view
      raise "Need focal length and format size to determine angle of view" unless @lens && @lens.focal_length && @format
      @format.angle_of_view(@lens.focal_length)
    end

    def print(io=STDOUT)
      io.puts "#{@name}: format: #{@format}, shutter: #{@max_shutter}~#{@min_shutter}"
      @lenses.sort_by(&:focal_length).each do |lens|
        io.puts "\t%s %s: focal length: %s [%s], aperture: %s~%s [%s~%s], angle of view: %s" % [
          (lens == @lens) ? '*' : ' ',
          lens.name,
          lens.focal_length,
          @format.focal_length_equivalent(lens.focal_length),
          lens.max_aperture,
          lens.min_aperture,
          @format.aperture_equivalent(lens.max_aperture),
          @format.aperture_equivalent(lens.min_aperture),
          @format.angle_of_view(lens.focal_length),
        ]
      end
    end

  end

end