module PhotoUtils

  class Tools

    class CamerasTool < Tool

      def run
        Cameras.each do |camera|
          camera.print
        end
      end

    end

  end

end