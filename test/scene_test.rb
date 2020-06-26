require_relative 'test'

module PhotoUtils

  class SceneTest < Test

    def setup
      @camera = Cameras.generic_35mm
      @scene = Scene.new(
        camera: @camera,
        subject_distance: 1000)
    end

    def test_depth_of_field
      @scene.calculate_depth_of_field!
      assert { @scene.subject_distance == 1000 }
      assert { @scene.in_focus?(@scene.subject_distance) }
      assert { !@scene.in_focus?(0) }
      assert { @scene.magnification.round(2) == 0.05 }
      assert { @scene.depth_of_field.round == 185 }
      assert { @scene.foreground_distance.round == 916 }
      assert { @scene.background_distance.round == 1101 }
      assert { @scene.hyperfocal_distance.round == 10884 }
    end

    def test_exposure
      @scene.shutter = TimeValue.new_from_v(0)
      @scene.aperture = ApertureValue.new_from_v(0)
      @scene.sensitivity = SensitivityValue.new_from_v(0)
      @scene.brightness = BrightnessValue.new_from_v(0)
      @scene.calculate_exposure!
      assert { @scene.exposure.to_v == 0 }
      assert { @scene.shutter.to_v == 0 }
      assert { @scene.aperture.to_v == 0 }
      assert { @scene.brightness.to_v == 0 }
      assert { @scene.sensitivity.to_v == 0 }
    end

  end

end