# coding: utf-8

module PhotoUtils

  class Lens
    
    attr_accessor :name
    attr_reader   :focal_length
    attr_accessor :min_aperture
    attr_accessor :max_aperture
    
    def initialize(params={})
      params.each do |key, value|
        method("#{key}=").call(value)
      end
    end
    
    def name
      @name || @focal_length.to_s
    end
    
    def focal_length=(f)
      @focal_length = Length.new(f)
    end
    
    def min_aperture=(a)
      @min_aperture = Aperture.new(a)
    end
    
    def max_aperture=(a)
      @max_aperture = Aperture.new(a)
    end
    
    def print(params={})
      indent = params[:indent] || 0
      io = params[:io] || STDOUT
      io.puts "#{"\t" * indent}#{name}: focal length: #{focal_length}, aperture: #{max_aperture} - #{min_aperture}"
    end

  end
  
end