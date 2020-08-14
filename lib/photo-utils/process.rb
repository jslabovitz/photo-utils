module PhotoUtils

  class Process

    attr_reader   :key
    attr_accessor :make
    attr_accessor :name
    attr_accessor :dilution

    def initialize(params={})
      params.each { |k, v| send("#{k}=", v) }
    end

    def key=(key)
      @key = Table.make_key(key)
    end

    def to_s
      '%s (%s %s, dilution %s)' % [
        @key,
        @make,
        @name,
        @dilution,
      ]
    end

  end

  Processes = Table.load(file: ProcessesFile, item_class: Process)

end