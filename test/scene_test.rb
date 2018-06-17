require_relative 'test'

module PhotoUtils

  class SceneTest < Test

    def setup
      @camera = Camera[/Generic 35mm/]
      @scene = Scene.new(
        camera: @camera,
        subject_distance: 10.feet)
    end

    def test_blur
      assert { @scene.in_focus?(@scene.subject_distance) }
      assert { !@scene.in_focus?(0) }
    end

  end

end