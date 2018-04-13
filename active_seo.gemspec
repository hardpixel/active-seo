# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'active_seo/version'

Gem::Specification.new do |spec|
  spec.name          = 'active_seo'
  spec.version       = ActiveSeo::VERSION
  spec.authors       = ['Olibia Tsati']
  spec.email         = ['olibia@hardpixel.eu']
  spec.summary       = %q{Add SEO meta to ActiveRecord models}
  spec.description   = %q{Optimize ActiveRecord models with support for SEO, Twitter and Open Graph meta.}
  spec.homepage      = 'https://github.com/hardpixel/active-seo'
  spec.license       = 'MIT'
  spec.files         = Dir['{lib/**/*,[A-Z]*}']
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_dependency 'activerecord', '~> 5.0'
  spec.add_dependency 'actionview', '~> 5.0'
  spec.add_dependency 'active_delegate', '~> 0.1'
  spec.add_dependency 'hashie', '~> 3.5'
  spec.add_development_dependency 'bundler', '~> 1.14'
  spec.add_development_dependency 'rake', '~> 10.0'
  spec.add_development_dependency 'minitest', '~> 5.0'
end
