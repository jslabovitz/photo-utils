require 'photo_utils/tool'

module PhotoUtils
  
  class Tools
    
    class FocalLength < Tool
      
      def run(args)
        from_focal_length, from_format = args.shift.split(':')
        from_focal_length = from_focal_length.to_i
        from_format = (Format[from_format || '35'] or raise "Unknown format: #{from_format.inspect}")
        to_formats = args.first ? args.shift.split(',') : %w{1/1.7 APS-C APS-H 35 6x4.5 6x6 6x7 5x7}
        to_formats.map { |f| Format[f] or raise "Unknown format: #{f.inspect}" }.each do |to_format|
          scene = Scene.new
          scene.format = from_format
          puts "%10s: %6s" % [to_format.name, scene.format.focal_length_equivalent(from_focal_length, to_format)]
        end
      end
      
    end
    
  end
  
end