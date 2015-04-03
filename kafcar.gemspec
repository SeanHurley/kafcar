# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'kafcar/version'

Gem::Specification.new do |spec|
  spec.name          = "kafcar"
  spec.version       = Kafcar::VERSION
  spec.authors       = ["hurley"]
  spec.email         = ["sean.hurley6@gmail.com"]
  spec.summary       = %q{A ruby client for talking to kafka}
  spec.description   = %q{A super awesome ruby client for talking to kafka}
  spec.homepage      = "https://github.com/SeanHurley/kafcar"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.7"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.2"
end
