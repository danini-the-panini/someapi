# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'someapi/version'

Gem::Specification.new do |spec|
  spec.name          = "someapi"
  spec.version       = Some::VERSION
  spec.authors       = ["Daniel Smith"]
  spec.email         = ["jellymann@gmail.com"]
  spec.summary       = %q{A generic RESTful API wrapper.}
  spec.description   = %q{Built around HTTParty, SomeAPI provides a generic wrapper for your favourite RESTful WebAPI. Simply extend Some::API and apply your usual HTTParty options like base_uri, then call your new API and party harder!}
  spec.homepage      = "https://github.com/jellymann/someapi"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_runtime_dependency "httparty", "~> 0.13.1"

  spec.add_development_dependency "bundler", "~> 1.6"
  spec.add_development_dependency "rake"
end
