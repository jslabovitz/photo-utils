# coding: utf-8

require 'pathname'

module PhotoUtils

  class Camera
    
    CAMERAS_PATH = Pathname.new(ENV['HOME']) + '.cameras.rb'
    
    def self.cameras
      unless class_variable_defined?('@@cameras')
        if CAMERAS_PATH.exist?
          class_variable_set('@@cameras', eval(CAMERAS_PATH.read))
        end
      end
      class_variable_get('@@cameras')
    end
    
    def self.find(params)
      if (sel = params[:name])
        cameras.find { |c| sel === c.name }
      else
        raise "Don't know how to search for camera with params: #{params.inspect}"
      end
    end
    
    attr_accessor :name
    attr_accessor :format
    attr_accessor :min_shutter
    attr_accessor :max_shutter
    attr_accessor :lenses
    
    def initialize(params={})
      params.each do |key, value|
        method("#{key}=").call(value)
      end
    end
    
    def min_shutter=(t)
      @min_shutter = Time.new(t)
    end
    
    def max_shutter=(t)
      @max_shutter = Time.new(t)
    end
    
    def print(params={})
      indent = params[:indent] || 0
      io = params[:io] || STDOUT
      io.puts "#{"\t" * indent}#{name}: format: #{format}, shutter: #{max_shutter} - #{min_shutter}"
      frame = FORMATS[format]
      @lenses.sort_by(&:focal_length).each do |lens|
        io.puts "#{"\t" * (indent + 1)}#{lens.name}: focal length: #{lens.focal_length} (35mm equiv: #{frame.focal_length_equivalent(lens.focal_length)}), aperture: #{lens.max_aperture} - #{lens.min_aperture}"
      end
    end
    
  end

end