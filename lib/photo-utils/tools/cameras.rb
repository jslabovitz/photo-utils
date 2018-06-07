require 'photo-utils/tool'

module PhotoUtils

  class Tools

    class Cameras < Tool

      def run
        if Camera.cameras
          Camera.cameras.each do |camera|
            camera.print
            puts
          end
        else
          warn "No cameras found."
        end
      end

    end

  end

end
