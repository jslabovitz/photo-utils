require 'test/unit'
require 'wrong'
require 'photo_utils'

class TestExposure < Test::Unit::TestCase
  
  include Wrong
  include PhotoUtils
  
  def setup
	  @e = Exposure.new(10)
  end
  
  def test_has_correct_native_value
	  assert { @e.to_f == 10 }
  end

  def test_format_as_string
	  assert { @e.to_s == 'Ev 10' }
	  assert { @e.to_s(:value) == 'Ev:10' }
  end
	
  def test_converts_to_value
	  assert { @e.to_v.round == Exposure.new_from_v(10).to_v }
  end
  
  def test_increments_and_decrements
	  assert { @e.incr.round == Exposure.new(11).round }
	  assert { @e.decr.round == Exposure.new(9).round  }
  end
  
end