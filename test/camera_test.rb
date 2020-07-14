require_relative 'test'

module PhotoUtils

  class CameraTest < Test

    def setup
      @camera = Cameras.generic_35mm
    end

    def test_generic_35mm
      assert { @camera.key == 'g35' }
      assert { @camera.make == 'Generica' }
      assert { @camera.model == '35' }
      assert { @camera.backs.map(&:key) == ['135'] }
      assert { @camera.primary_format.key == '135' }
    end

    def test_find
      assert { Cameras[@camera.key] == @camera }
    end

    def test_lens
      lens = @camera.normal_lens(@camera.primary_format)
      assert { lens.key == '50mm' }
      assert { lens.min_aperture == 22 }
      assert { lens.max_aperture == 2.8 }
    end

  end

end