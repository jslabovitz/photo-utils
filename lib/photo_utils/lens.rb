# coding: utf-8

module PhotoUtils

  class Lens
    
    attr_accessor :name
    attr_reader   :focal_length
    attr_accessor :min_aperture
    attr_accessor :max_aperture
    attr_accessor :aperture
    
    def initialize(params={})
      params.each do |key, value|
        method("#{key}=").call(value)
      end
      @aperture = @max_aperture
    end
    
    def inspect
      "<#{self.class}: name=#{@name.inspect}, focal_length=#{@focal_length.inspect}, min_aperture=#{@min_aperture.inspect}, max_aperture=#{@max_aperture.inspect}, aperture=#{@aperture.inspect}>"
    end
    
    def to_s
      if @name
        "#{@name} (#{@focal_length})"
      else
        @focal_length.to_s
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
    
    def aperture=(a)
      @aperture = Aperture.new(a)
    end

  end
  
end