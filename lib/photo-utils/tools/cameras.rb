module PhotoUtils

  class Tools

    class Cameras < Tool

      def run
        Camera.cameras.each do |camera|
          camera.print
        end
      end

    end

  end

end