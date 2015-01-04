# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'gamework/version'

Gem::Specification.new do |spec|
  spec.name          = "gamework"
  spec.version       = Gamework::VERSION
  spec.authors       = ["Steve Aquino"]
  spec.email         = ["aquino.steve@gmail.com"]
  spec.description   = %q{An MVC Game Making Framework}
  spec.summary       = %q{An easy to use MVC game making framework built on Gosu.}
  spec.homepage      = "https://github.com/SteveAquino/gamework"
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_dependency 'gosu', '0.8.6'
  spec.add_dependency 'i18n'
  spec.add_dependency 'activesupport', '~> 3.0.0'
  spec.add_dependency 'colorize'
  spec.add_dependency 'thor'
  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "rspec"
  spec.add_development_dependency "fuubar"
  spec.add_development_dependency "pry"
  spec.add_development_dependency "simplecov"
end
