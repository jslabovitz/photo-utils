require 'test/unit'
require 'wrong'
require 'photo_utils'

class TestScene < Test::Unit::TestCase
  
  include Wrong
  include PhotoUtils
  
  def setup
    @scene = Scene.new
    @scene.subject_distance = 30.feet
    @scene.sensitivity = 1600
    @scene.brightness = 64
    @scene.frame = FORMATS['6x6']
    @scene.focal_length = 80.mm
    @scene.aperture = 4
  end
  
  def test_make_scene
    assert { @scene }
	end
	
	def test_blur_is_zero_at_subject
    blur = @scene.blur_at_distance(@scene.subject_distance)
    assert { blur == 0 }
  end
	
end

=begin

0.upto(10) { |v| puts PhotoUtils::Aperture.new_from_v(v).to_s(:value) }
puts

0.upto(10) { |v| puts PhotoUtils::Time.new_from_v(v).to_s(:value) }
puts

0.upto(10) { |v| puts PhotoUtils::Sensitivity.new_from_v(v).to_s(:value) }
puts

0.upto(10) { |v| puts PhotoUtils::Brightness.new_from_v(v).to_s(:value) }
puts

=end