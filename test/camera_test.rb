require_relative 'test'

module PhotoUtils

  class CameraTest < Test

    def setup
      @camera = Camera[/Generic 35mm/]
    end

    def test_camera
      assert { @camera.name == 'Generic 35mm' }
      assert { @camera.formats.map(&:name) == ['35'] }
    end

    def test_lens
      lens = @camera.normal_lens(@camera.formats.first)
      assert { lens.name == '50mm' }
      assert { lens.min_aperture == 22 }
      assert { lens.max_aperture == 2.8 }
    end

  end

end