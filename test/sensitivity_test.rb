require 'test/unit'
require 'wrong'
require 'photo-utils'

class TestSensitivity < Test::Unit::TestCase

  include Wrong
  include PhotoUtils

  def setup
	  @s = Sensitivity.new(400)
  end

  def test_zero_value
    assert { Sensitivity.new(3.125).to_v == 0 }
  end

  def test_has_correct_native_value
	  assert { @s.to_f == 400 }
  end

  def test_format_as_string
	  assert { @s.to_s == 'ISO 400' }
	  assert { @s.to_s(:value) == 'Sv:7' }
  end

  def test_converts_to_value
	  assert { @s.to_v.round == Sensitivity.new_from_v(7).to_v }
  end

  def test_increments_and_decrements
	  assert { @s.incr.round == Sensitivity.new(@s * 2).round }
	  assert { @s.decr.round == Sensitivity.new(@s / 2).round  }
  end

end