module PhotoUtils

  class Tools

    class CamerasTool < Tool

      def run
        if ARGV.empty?
          cameras = Cameras.to_a
        else
          cameras = ARGV.map { |a| Cameras[a] }
        end
        cameras.each do |camera|
          camera.print
        end
      end

    end

  end

end