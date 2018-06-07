require 'test/unit'
require 'wrong'
require 'photo-utils'

class TestAperture < Test::Unit::TestCase

  include Wrong
  include PhotoUtils

  def setup
	  @a = Aperture.new(8)
  end

  def test_zero_value
    assert { Aperture.new(1).to_v == 0 }
  end

  def test_has_correct_native_value
	  assert { @a.to_f == 8 }
  end

	def test_format_as_string
	  assert { @a.to_s == 'f/8' }
	  assert { @a.to_s(:value) == 'Av:6' }
  end

  def test_converts_to_value
	  assert { @a.to_v == Aperture.new_from_v(6).to_v }
  end

  def test_increments_and_decrements
	  assert { @a.incr.round == Aperture.new(11).round }
	  assert { @a.decr.round == Aperture.new(5.6).round  }
  end

  def test_absolute
	  assert { @a.absolute(50) == 6.25 }
  end

end