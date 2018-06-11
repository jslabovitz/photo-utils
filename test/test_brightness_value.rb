require_relative 'test'

module PhotoUtils

  class BrightnessValueTest < Test

    def setup
      @cdm2 = 3.4
      @b = BrightnessValue.new(@cdm2)
    end

    def test_value
      assert { @b.to_f == @cdm2 }
      assert { @b.to_v.round == 0 }
    end

    def test_format_as_string
      assert { @b.to_s == "#{@cdm2} cd/m2" }
      assert { @b.to_s(:value) == 'Bv:0' }
    end

    def test_increments_and_decrements
      assert { @b.incr.round == BrightnessValue.new(@b * 2).round }
      assert { @b.decr.round == BrightnessValue.new(@b / 2).round }
    end

  end

end