require 'test/unit'
require 'wrong'
require 'photo_utils'

class TestBrightness < Test::Unit::TestCase
  
  include Wrong
  include PhotoUtils
  
  def setup
	  @b = Brightness.new(128)
  end
  
  def test_has_correct_native_value
	  assert { @b.to_f == 128 }
  end

  def test_format_as_string
	  assert { @b.to_s == '128 cd/m2' }
	  assert { @b.to_s(:value) == 'Bv:5.1' }
  end
	
  def test_converts_to_value
	  assert { @b.to_v.round == Brightness.new_from_v(5).to_v }
  end
  
  def test_increments_and_decrements
	  assert { @b.incr.round == Brightness.new(256).round }
	  assert { @b.decr.round == Brightness.new(64).round  }
  end
  
end