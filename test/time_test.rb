require_relative 'test'

module PhotoUtils

  class TestTime < Test

    def setup
  	  @t = TimeValue.new(1)
    end

    def test_has_correct_values
      assert { @t == 1 }
      assert { @t.to_v == 0 }
    end

    def test_format_as_string
  	  assert { @t.to_s(:value) == 'Tv:0' }
      assert { TimeValue.new(Rational(1, 30)).to_s == '1/30s' }
  	  assert { TimeValue.new(10).to_s == '10s' }
    end

    def test_converts_to_value
  	  assert { @t.to_v == TimeValue.new_from_v(@t.to_v).to_v }
    end

    def test_increments_and_decrements
  	  assert { @t.incr.to_v.round == TimeValue.new(@t * 2).to_v.round  }
  	  assert { @t.decr.to_v.round == TimeValue.new(@t / 2).to_v.round }
    end

  end

end