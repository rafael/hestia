# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "hestia/version"

Gem::Specification.new do |s|
  s.name        = "hestia"
  s.version     = Hestia::VERSION
  s.authors     = ["Rafael Chacon", "Roman Gonzalez"]
  s.email       = ["rafaelchacon@noomii.com", "roman@nomii.com"]
  s.homepage    = ""
  s.summary     = %q{Tasks to do house keeping of the system}
  s.description = %q{This gem include a set of commands to ease the process of handling aws instances}

  s.rubyforge_project = "hestia"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  # specify any dependencies here; for example:
  s.add_development_dependency "rspec-core"
  s.add_development_dependency "minitest"
  s.add_runtime_dependency "fog", "= 1.3.1"
  s.add_runtime_dependency "thor", "= 0.15.3"
  s.add_runtime_dependency "activesupport", "= 3.1.3"
end
