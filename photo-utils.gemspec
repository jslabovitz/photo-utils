# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{photo-utils}
  s.version = "0.0.1"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["John Labovitz"]
  s.date = %q{2011-06-08}
  s.default_executable = %q{photo-util}
  s.email = %q{johnl@johnlabovitz.com}
  s.executables = ["photo-util"]
  s.files = ["lib/photo_utils/angle.rb", "lib/photo_utils/aperture.rb", "lib/photo_utils/apex.rb", "lib/photo_utils/brightness.rb", "lib/photo_utils/camera.rb", "lib/photo_utils/extensions/array.rb", "lib/photo_utils/extensions/float.rb", "lib/photo_utils/extensions/math.rb", "lib/photo_utils/extensions/numeric.rb", "lib/photo_utils/formats.rb", "lib/photo_utils/frame.rb", "lib/photo_utils/length.rb", "lib/photo_utils/lens.rb", "lib/photo_utils/scene.rb", "lib/photo_utils/scene_view.rb", "lib/photo_utils/sensitivity.rb", "lib/photo_utils/time.rb", "lib/photo_utils/tool.rb", "lib/photo_utils/tools/blur.rb", "lib/photo_utils/tools/brightness.rb", "lib/photo_utils/tools/calc_aperture.rb", "lib/photo_utils/tools/cameras.rb", "lib/photo_utils/tools/chart_dof.rb", "lib/photo_utils/tools/compare.rb", "lib/photo_utils/tools/dof.rb", "lib/photo_utils/tools/dof_table.rb", "lib/photo_utils/tools/film_test.rb", "lib/photo_utils/tools/focal_length.rb", "lib/photo_utils/tools/reciprocity.rb", "lib/photo_utils/tools/test.rb", "lib/photo_utils/value.rb", "lib/photo_utils.rb", "bin/photo-util"]
  s.homepage = %q{http://johnlabovitz.com}
  s.rdoc_options = ["--main", "README"]
  s.require_paths = ["lib"]
  s.rubygems_version = %q{1.6.2}
  s.summary = %q{Models, formulas, and utilties for photography optics, etc.}

  if s.respond_to? :specification_version then
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<hashstruct>, [">= 0"])
      s.add_development_dependency(%q<wrong>, [">= 0"])
    else
      s.add_dependency(%q<hashstruct>, [">= 0"])
      s.add_dependency(%q<wrong>, [">= 0"])
    end
  else
    s.add_dependency(%q<hashstruct>, [">= 0"])
    s.add_dependency(%q<wrong>, [">= 0"])
  end
end
