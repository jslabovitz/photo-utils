require_relative 'test'

module PhotoUtils

  class CameraTest < Test

    def setup
      @camera = Camera.generic_35mm
    end

    def test_generic_35mm
      assert { @camera.key == 'g35' }
      assert { @camera.make == 'Generica' }
      assert { @camera.model == 'G35' }
      assert { @camera.formats.map(&:name) == ['35'] }
    end

    def test_find
      assert { Camera.find(@camera.key) == @camera }
    end

    def test_lens
      lens = @camera.normal_lens(@camera.formats.first)
      assert { lens.key == '50mm' }
      assert { lens.min_aperture == 22 }
      assert { lens.max_aperture == 2.8 }
    end

  end

end