# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "continuum/version"

Gem::Specification.new do |s|
  s.name        = "continuum"
  s.version     = Continuum::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Josh Kleinpeter"]
  s.email       = ["josh@kleinpeter.org"]
  s.homepage    = ""
  s.summary     = %q{A Ruby gem that interfaces with OpenTSDB.}
  s.description = %q{A Ruby gem that interfaces with OpenTSDB.}

  s.rubyforge_project = "continuum"
  s.add_dependency 'hugs'
  s.add_development_dependency 'vcr'

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]
end
