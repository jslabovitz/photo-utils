module PhotoUtils

  class Table

    include Enumerable

    def self.make_key(key)
      key.to_s.downcase
    end

    def initialize(items=nil)
      @items = {}
      add_items(items) if items
    end

    def add_items(items)
      items.each { |i| self << i }
    end

    def <<(item)
      key = make_key(item.key)
      raise "Duplicate key: #{key.inspect} for #{self}" if @items.has_key?(key)
      @items[key] = item
    end

    def first
      @items.values.first
    end

    def last
      @items.values.last
    end

    def length
      @items.values.length
    end

    def each(&block)
      @items.values.each(&block)
    end

    def [](key)
      @items[make_key(key)]
    end

    def make_key(key)
      self.class.make_key(key)
    end

    def load_file(file:, item_class: OpenStruct)
      [DefaultDataDir, UserDataDir].each do |dir|
        path = dir / file
        if path.exist?
          begin
            yaml = YAML.load(path.read, symbolize_names: true)
          rescue Psych::SyntaxError => e
            raise Error, "Syntax error in #{path.to_s.inspect}: #{e}"
          end
          if yaml
            yaml.each do |key, info|
              self << item_class.new(**info.merge(key: key))
            end
          end
        end
      end
    end

  end

end