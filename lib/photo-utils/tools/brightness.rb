require 'photo-utils/tool'

module PhotoUtils

  class Tools

    class Brightness < Tool

      def run
        scene = Scene.new
        scene.camera = Camera[/Rollei/]
        scene.description = "Salon L'Orient"
        scene.print_exposure
      end

    end

  end

end