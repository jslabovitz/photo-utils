module PhotoUtils

  class Camera

    CAMERAS_PATH = Path.new(ENV['HOME']) / '.cameras.rb'

    def self.cameras
      unless class_variable_defined?('@@cameras')
        if CAMERAS_PATH.exist?
          @@cameras = eval(CAMERAS_PATH.read)
        end
      end
      @@cameras
    end

    def self.find(params)
      if (sel = params[:name])
        cameras.find { |c| sel === c.name }
      else
        raise "Don't know how to search for camera with params: #{params.inspect}"
      end
    end

    def self.[](name)
      find(name: name)
    end

    attr_accessor :name
    attr_accessor :formats
    attr_accessor :format
    attr_accessor :min_shutter
    attr_accessor :max_shutter
    attr_accessor :shutter
    attr_accessor :lenses
    attr_accessor :lens

    def initialize(params={})
      if params[:format]
        params[:formats] = [params.delete(:format)]
      end
      params.each { |k, v| send("#{k}=", v) }
      @format ||= @formats.first
      normal = @format.frame.diagonal
      # set the lens to the one closest to normal (diagonal of frame)
      @lens = @lenses.sort_by { |l| (normal - l.focal_length).abs }.first
      @shutter = @max_shutter
    end

    def min_shutter=(t)
      @min_shutter = t ? Time.new(t) : nil
    end

    def max_shutter=(t)
      @max_shutter = t ? Time.new(t) : nil
    end

    def shutter=(t)
      @shutter = t ? Time.new(t) : nil
    end

    def angle_of_view
      raise "Need focal length and format size to determine angle of view" unless @lens && @lens.focal_length && @format
      @format.angle_of_view(@lens.focal_length)
    end

    def print(io=STDOUT)
      io.puts "#{@name}: format: #{@format}, shutter: #{@max_shutter} - #{@min_shutter}"
      @lenses.sort_by(&:focal_length).each do |lens|
        io.puts "\t%s %s: focal length: %s [%s], aperture: %s~%s [%s~%s], angle of view: %s" % [
          (lens == @lens) ? '*' : ' ',
          lens.name,
          lens.focal_length.format_metric(1),
          @format.focal_length_equivalent(lens.focal_length).format_metric(1),
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