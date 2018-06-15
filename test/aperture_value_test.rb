require_relative 'test'

module PhotoUtils

  class ApertureValueTest < Test

    def setup
  	  @a = ApertureValue.new(1)
    end

    def test_value
      assert { @a.to_f == 1 }
      assert { @a.to_v == 0 }
      assert { @a.us_stop == 0.0625 }
    end

    def test_format_as_string
      assert { @a.to_s == 'f/1' }
      assert { @a.to_s(:value) == 'Av:0' }
    end

    def test_converts_to_value
      assert { @a == ApertureValue.new_from_v(@a.to_v) }
    end

    def test_increments_and_decrements
  	  assert { @a.incr.to_v.round == ApertureValue.new(1.4).to_v.round }
  	  assert { @a.decr.to_v.round == ApertureValue.new(0.7).to_v.round  }
    end

    def test_parse_fstop
      assert { ApertureValue.parse('f/1') == 1 }
      assert { ApertureValue.parse('f/2.8') == 2.8 }
      assert { ApertureValue.parse('f/16') == 16 }
    end

    def test_parse_us_stop
      [
        [4,    1],
        [5.7,  2],
        [8,    4],
        [11,   8],
        [16,  16],
        # [22,  32],    # 30.250000000000004
        [32,  64],
        # [45, 128],   # 126.56250000000001
        [64, 256],
      ].each do |f, us, str|
        str = "US #{us}"
        assert { ApertureValue.new(f).us_stop.round == us }
        assert { ApertureValue.new(f).to_s(:us) == str }
        assert { ApertureValue.parse(str).round == f.round }
      end
    end

    def test_range
      r = ApertureValue.new(1) .. ApertureValue.new(4)
      assert { r.to_a.map { |n| n.round(1) } == [1, 1.4, 2, 2.8, 4] }
    end

  end

end