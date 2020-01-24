# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "ringflux/version"

Gem::Specification.new do |s|
  s.name        = "ringflux"
  s.version     = Ringflux::VERSION
  s.authors     = ["Ben Klang"]
  s.email       = ["bklang@powerhrg.com"]
  s.homepage    = "https://github.com/powerhome/ringflux"
  s.summary     = %q{InfluxDB plugin for Adhearsion}
  s.description = %q{This gem provides a plugin for Adhearsion, allowing you to publish metrics to InfluxDB}

  s.license     = 'MIT'

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.require_paths = ["lib"]

  s.add_runtime_dependency %q<adhearsion>, ["~> 2.1"]
  s.add_runtime_dependency %q<influxdb>, ["~> 0.3"]

  s.add_development_dependency %q<bundler>, ["~> 1.0"]
  s.add_development_dependency %q<rspec>, ["~> 2.5"]
  s.add_development_dependency %q<rake>, [">= 0"]
  s.add_development_dependency %q<yard>
  s.add_development_dependency %q<guard-rspec>
 end
