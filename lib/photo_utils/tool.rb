module PhotoUtils
  
  class Tool
    
    def usage
    end
    
    def run(args)
      raise UnimplementedMethod, "Tool #{self.class} does not implement \#run"
    end
    
  end
  
end