require_relative 'test'

module PhotoUtils

  class CameraTest < Test

    def setup
      @camera = Camera[/Generic 35mm/]
    end

    def test
      assert { @camera.name == 'Generic 35mm' }
      assert { @camera.format.name == '35' }
      assert { @camera.lens.name == '50mm' }
      assert { @camera.angle_of_view == 47 }
      lens = @camera.lens
      assert { lens == @camera.normal_lens }
      assert { lens.min_aperture == 22 }
      assert { lens.max_aperture == 2.8 }
    end

  end

end