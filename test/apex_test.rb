require_relative 'test'

module PhotoUtils

  class TestAPEX < Test

    def setup
      @exposure = Exposure.new(
        time: nil,
        aperture: 8,
        sensitivity: 200,
        brightness: Brightness.new_from_v(5))
    end

    def test_apex
      assert { @exposure.ev                 == @exposure.av + @exposure.tv }
      assert { @exposure.bv + @exposure.sv  == @exposure.av + @exposure.tv }
    end

    def test_exposure
      assert { @exposure.ev    == 11 }
      assert { @exposure.ev100 == 0 }
    end

  end

end