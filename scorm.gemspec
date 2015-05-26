# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'scorm/version'

Gem::Specification.new do |spec|
  spec.name          = "scorm"
  spec.version       = Scorm::VERSION
  spec.authors       = ["Per Christian B. Viken"]
  spec.email         = ["perchr@northblue.org"]
  spec.description   = %q{The important bits of the SCORM 2004 4th Edition Standard. If time permits, this gem should support the other versions of the standard as well.}
  spec.summary       = %q{The important bits of the SCORM 2004 4th Edition Standard}
  spec.homepage      = "https://eastblue.org/blag/"
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_dependency "nokogiri", "~> 1.6.6"
  spec.add_dependency "virtus",   "~> 1.0.5"
  spec.add_development_dependency "bundler", "~> 1.2"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "rspec", "~> 2.11"
end
