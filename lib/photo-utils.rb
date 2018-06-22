require 'pp'
require 'hashstruct'
require 'builder'
require 'path'
require 'delegate'
require 'yaml'

module PhotoUtils

  class Error < Exception; end

end

require 'photo-utils/extensions/numeric'

require 'photo-utils/constants'

require 'photo-utils/values/value'
require 'photo-utils/values/aperture'
require 'photo-utils/values/brightness'
require 'photo-utils/values/exposure'
require 'photo-utils/values/illuminance'
require 'photo-utils/values/sensitivity'
require 'photo-utils/values/time'

require 'photo-utils/length'
require 'photo-utils/angle'

require 'photo-utils/lens'
require 'photo-utils/camera'
require 'photo-utils/frame'
require 'photo-utils/formats'
require 'photo-utils/scene'
require 'photo-utils/scene_view'

require 'photo-utils/tool'
require 'photo-utils/tools/cameras'
require 'photo-utils/tools/chart_dof'
require 'photo-utils/tools/compare'
require 'photo-utils/tools/dof'
require 'photo-utils/tools/dof_table'
require 'photo-utils/tools/film_test'
require 'photo-utils/tools/reciprocity'

module PhotoUtils

  def self.format_float(n, precision=1)
    ((n.round == n.to_f || n.round == 0) ? n.round : n.round(precision)).to_s
  end

  Camera.read_cameras

end