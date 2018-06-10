require_relative 'test'

module PhotoUtils

  class TestBrightness < Test

    def setup
  	  @b = BrightnessValue.new(1)
    end

    def value
  	  assert { @b.to_f == 1 }
      assert { @b.to_v.round == 0 }
    end

    def test_format_as_string
  	  assert { @b.to_s == '1 cd/m2' }
  	  assert { @b.to_s(:value) == 'Bv:0' }
    end

    def test_increments_and_decrements
  	  assert { @b.incr.round == BrightnessValue.new(@b * 2).round }
  	  assert { @b.decr.round == BrightnessValue.new(@b / 2).round }
    end

  end

end