require 'test/unit'
require 'wrong'
require 'photo_utils'

class TestBrightness < Test::Unit::TestCase
  
  include Wrong
  include PhotoUtils
  
  def setup
	  @b = Brightness.new(1)
  end
  
  def test_zero_value
    assert { Brightness.new(1).to_v == 0 }
  end
  
  def test_has_correct_native_value
	  assert { @b.to_f == 1 }
  end

  def test_format_as_string
	  assert { @b.to_s == '1 fL' }
	  assert { @b.to_s(:value) == 'Bv:0' }
  end
	
  def test_converts_to_value
	  assert { @b.to_v == 0 }
  end
  
  def test_increments_and_decrements
	  assert { @b.incr.round == Brightness.new(@b * 2).round }
	  assert { @b.decr.round == Brightness.new(@b / 2).round }
  end
  
end