module PhotoUtils

  class Back

    attr_reader   :key
    attr_reader   :format
    attr_accessor :frames

    def initialize(params={})
      params.each { |k, v| send("#{k}=", v) }
    end

    def key=(key)
      @key = Table.make_key(key)
    end

    def format=(format)
      @format = case format
      when Format
        format
      when Hash
        Format.new(**format)
      when String, Numeric
        Formats[format] or raise "Unknown format key #{format.inspect}"
      else
        raise "Unknown format object: #{format.inspect}"
      end
    end

    def to_s
      '%s (%sx %s)' % [
        @key,
        @frames || '?',
        @format,
      ]
    end

  end

end