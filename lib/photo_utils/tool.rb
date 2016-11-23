module PhotoUtils

  class Tool

    def initialize
    end

    def name
      self.class.to_s.split('::').last.downcase
    end

    def usage
      warn "#{$0} #{name} ..."
    end

    def description
    end

    def run
    end

  end

end