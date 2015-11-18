require 'test/unit'
require 'wrong'
require 'photo_utils'

class TestTime < Test::Unit::TestCase

  include Wrong
  include PhotoUtils

  def setup
	  @t = Time.new(1.0 / 10)
  end

  def test_zero_value
    assert { Time.new(1).to_v == 0 }
  end

  def test_has_correct_native_value
	  assert { @t.to_f == 0.1 }
  end

  def test_format_as_string
	  assert { @t.to_s == '1/10' }
	  assert { @t.to_s(:value) == 'Tv:3.3' }
	  assert { Time.new(10).to_s == '10s' }
  end

  def test_converts_to_value
	  assert { @t.to_v.round == Time.new_from_v(3).to_v }
  end

  def test_increments_and_decrements
	  assert { @t.incr.round == Time.new(@t * 2).round  }
	  assert { @t.decr.round == Time.new(@t / 2).round }
  end

  def test_reciprocity
	  assert { Time.new(1).reciprocity.round  == Time.new(1) }
	  assert { Time.new(10).reciprocity.round == Time.new(23) }
  end

end