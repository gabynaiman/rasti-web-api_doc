# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'rasti/web/api_doc/version'

Gem::Specification.new do |spec|
  spec.name          = 'rasti-web-api_doc'
  spec.version       = Rasti::Web::ApiDoc::VERSION
  spec.authors       = ['Gabriel Naiman']
  spec.email         = ['gabynaiman@gmail.com']

  spec.homepage      = 'https://github.com/gabynaiman/rasti-web-api_doc'
  spec.description   = 'Generate documentation of endpoint usage based on tests'
  spec.summary       = 'Generate documentation of endpoint usage based on tests'
  spec.license       = 'MIT'

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_dependency 'colorin', '~> 2.0'
  spec.add_dependency 'rasti-web'
  spec.add_dependency 'rake'
  spec.add_dependency 'rack-test'

  spec.add_development_dependency 'bundler', '~> 1.11'
end
