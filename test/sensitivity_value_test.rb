require_relative 'test'

module PhotoUtils

  class SensitivityValueTest < Test

    def setup
  	  @s = SensitivityValue.new(400)
    end

    def test_zero_value
      assert { SensitivityValue.new(3.125).to_v == 0 }
    end

    def test_has_correct_native_value
  	  assert { @s.to_f == 400 }
    end

    def test_format_as_string
  	  assert { @s.to_s == 'ISO 400' }
  	  assert { @s.to_s(:value) == 'Sv:7' }
    end

    def test_converts_to_value
  	  assert { @s.to_v.round == SensitivityValue.new_from_v(7).to_v }
    end

    def test_increments_and_decrements
  	  assert { @s.incr.round == SensitivityValue.new(@s * 2).round }
  	  assert { @s.decr.round == SensitivityValue.new(@s / 2).round  }
    end

  end

end