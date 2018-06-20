require_relative 'test'

module PhotoUtils

  class ExposureValueTest < Test

    def setup
      @e = ExposureValue.new_from_v(0)
    end

    def test_value
      assert { @e.to_f == 1 }
      assert { @e.to_v == 0 }
    end

    def test_format_as_string
      assert { @e.to_s == 'Ev:0' }
      assert { @e.to_s(:value) == 'Ev:0' }
    end

    def test_converts_to_value
      assert { @e == ExposureValue.new_from_v(@e.to_v) }
    end

  end

end