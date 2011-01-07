require 'test/unit'
require 'wrong'
require 'photo_utils'

class TestScene < Test::Unit::TestCase
  
  include Wrong
  include PhotoUtils
  
  def setup
    @scene = Scene.new
    @scene.subject_distance = 10.feet
    @scene.sensitivity = 200
    @scene.brightness = 1
    @scene.frame = FORMATS['6x6']
    @scene.focal_length = 80.mm
    @scene.aperture = 8
  end
  
  def test_make_scene
    assert { @scene }
	end
	
	def test_blur_is_zero_at_subject
    blur = @scene.blur_at_distance(@scene.subject_distance)
    assert { blur == 0 }
  end
	
	# test main APEX equations
	
	def test_apex
	  assert { @scene.ev              == @scene.av + @scene.tv }
	  assert { @scene.bv + @scene.sv  == @scene.av + @scene.tv }
  end
  
  def test_exposure
	  assert { (5..6).include?(@scene.ev)    }
	  assert { (4..5).include?(@scene.ev100) }
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