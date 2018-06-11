require_relative 'lib/photo-utils/version'

Gem::Specification.new do |s|
  s.name          = 'photo-utils'
  s.author        = 'John Labovitz'
  s.email         = 'johnl@johnlabovitz.com'
  s.homepage      = 'http://johnlabovitz.com'
  s.version       = PhotoUtils::VERSION
  s.summary       = 'Models, formulas, and utilties for photography optics, etc.'
  s.description = %q{
    PhotoUtils provides models, formulas, and utilties for photography optics, etc.
  }
  s.license       = 'MIT'
  s.homepage      = 'http://github.com/jslabovitz/photo-utils'

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- test/*_test.rb`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map { |f| File.basename(f) }
  s.require_path  = 'lib'

  s.add_runtime_dependency 'hashstruct', '~> 0'
  s.add_runtime_dependency 'builder', '~> 0'
  s.add_runtime_dependency 'path', '~> 0'

  s.add_development_dependency 'rake', '~> 12.3'
  s.add_development_dependency 'rubygems-tasks', '~> 0.2'
  s.add_development_dependency 'minitest', '~> 0'
  s.add_development_dependency 'minitest-power_assert', '~> 0'
end