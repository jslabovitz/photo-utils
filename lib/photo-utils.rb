require 'builder'
require 'pp'
require 'hashstruct'
require 'path'
require 'delegate'
require 'yaml'

module PhotoUtils

  class Error < Exception; end

  DefaultDataDir = Path.new(__FILE__).dirname / '..' / 'data'
  UserDataDir = Path.home / '.phu'
  FormatsFile = 'formats.yaml'
  CamerasFile = 'cameras.yaml'
  FilmsFile = 'films.yaml'
  ProcessesFile = 'processes.yaml'
  DefaultCamerasFile = DefaultDataDir / CamerasFile
  UserCamerasFile = UserDataDir / CamerasFile

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

require 'photo-utils/table'

require 'photo-utils/film'
require 'photo-utils/process'
require 'photo-utils/frame'
require 'photo-utils/format'
require 'photo-utils/back'
require 'photo-utils/lens'
require 'photo-utils/camera'
require 'photo-utils/scene'

require 'photo-utils/tool'
require 'photo-utils/tools/apertures'
require 'photo-utils/tools/cameras'
require 'photo-utils/tools/chart_dof'
require 'photo-utils/tools/compare'
require 'photo-utils/tools/dof'
require 'photo-utils/tools/dof_table'
require 'photo-utils/tools/film_test'
require 'photo-utils/tools/reciprocity'