module PhotoUtils

  class Format

    attr_reader   :key
    attr_reader   :frame
    attr_accessor :num_frames

    def initialize(params={})
      params.each { |k, v| send("#{k}=", v) }
    end

    def key=(key)
      @key = Table.make_key(key)
    end

    def frame=(frame)
      @frame = case frame
      when String, Numeric
        Frames[frame] or raise "Unknown frame key: #{frame.inspect}"
      when Hash
        Frame.new(**frame)
      else
        raise "Unknown frame object: #{frame.inspect}"
      end
    end

    def to_s
      '%s (%sx %s)' % [
        @key,
        @num_frames || '?',
        @frame,
      ]
    end

  end

end