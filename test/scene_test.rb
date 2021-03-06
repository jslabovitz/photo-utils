require 'test/unit'
require 'wrong'
require 'photo_utils'

class TestScene < Test::Unit::TestCase

  include Wrong
  include PhotoUtils

  def setup
    @scene = Scene.new
    @scene.camera = Camera[/RB67/]    #FIXME: Use generic
    @scene.subject_distance = 10.feet
  end

  def test_make_scene
    assert { @scene }
	end

	def test_blur_is_zero_at_subject
    blur = @scene.blur_at_distance(@scene.subject_distance)
    assert { blur == 0 }
  end

end