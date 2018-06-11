require_relative 'test'

module PhotoUtils

  class ExposureValueTest < Test

    def setup
      @time = TimeValue.new_from_v(0)
      @aperture = ApertureValue.new_from_v(0)
      @sensitivity = SensitivityValue.new_from_v(0)
      @brightness = BrightnessValue.new_from_v(0)
      @exposure = ExposureValue.new_from_v(0)
    end

    def test_calculate_time
      exposure = Exposure.calculate(
        time: nil,
        aperture: @aperture,
        sensitivity: @sensitivity,
        brightness: @brightness)
      assert { exposure.exposure == @exposure }
      assert { exposure.time == @time }
    end

  end

end