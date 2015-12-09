$LOAD_PATH << 'lib'

require 'photo_utils/version'

Gem::Specification.new do |s|

  s.name              = 'photo-utils'
  s.author            = 'John Labovitz'
  s.email             = 'johnl@johnlabovitz.com'
  s.homepage          = 'http://johnlabovitz.com'
  s.version           = PhotoUtils::VERSION
  s.summary           = 'Models, formulas, and utilties for photography optics, etc.'
  s.description = %q{
    PhotoUtils provides Models, formulas, and utilties for photography optics, etc.
  }

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_path  = 'lib'

  s.add_dependency 'hashstruct'
  s.add_dependency 'builder'
  s.add_dependency 'path'

  s.add_development_dependency 'bundler'
  s.add_development_dependency 'rake'
  s.add_development_dependency 'wrong'
end