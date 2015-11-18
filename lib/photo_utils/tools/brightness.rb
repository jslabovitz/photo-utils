require 'photo_utils/tool'

module PhotoUtils

  class Tools

    class Brightness < Tool

      def run(args)
        scene = Scene.new
        scene.camera = Camera[/Rollei/]
        scene.description = "Salon L'Orient"
        scene.print_exposure
      end

    end

  end

end