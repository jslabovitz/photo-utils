module PhotoUtils

  class Film

    attr_reader   :key
    attr_accessor :make
    attr_accessor :name
    attr_accessor :sensitivity
    attr_accessor :color
    attr_accessor :positive
    attr_accessor :process

    def initialize(params={})
      params.each { |k, v| send("#{k}=", v) }
    end

    def key=(key)
      @key = Table.make_key(key)
    end

    def to_s
      '%s (%s %s [%s], %s %s, %s)' % [
        @key,
        @make,
        @name,
        @sensitivity,
        @color ? 'color' : 'monochrome',
        @positive ? 'positive' : 'negative',
        @process,
      ]
    end

  end

  Films = Table.new
  Films.load_file(file: FilmsFile, item_class: Film)

end