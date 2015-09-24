# encoding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'pineapples/version'

Gem::Specification.new do |spec|
  spec.required_ruby_version     = ">= #{Pineapples::RUBY_VERSION}"
  spec.required_rubygems_version = '>= 2.1'

  spec.name        = 'pineapples'
  spec.version     = Pineapples::VERSION
  spec.authors     = ['Alexey Glukhov']
  spec.email       = ['gluhov985@gmail.com']
  spec.summary     = 'Generate a Rails app loaded with must-have gems and best practices'
  spec.description = <<-HERE
Rails app generator based on Suspenders by Thoughtbot and Raygun by Carbon Five modified to fit my own personal needs
  HERE
  spec.homepage    = 'http://github.com/pineapplethief/pineapples'
  spec.license     = 'MIT'

  spec.executables   = ['pineapples']
  spec.require_paths = ['lib']

  spec.extra_rdoc_files = %w[README.md LICENSE]
  spec.rdoc_options     = ['--charset=UTF-8']

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")



  spec.add_dependency 'rails', Pineapples::RAILS_VERSION
  spec.add_dependency 'bundler', '~> 1.10'
  spec.add_dependency 'colorize', '~> 0'

  spec.add_development_dependency 'rspec', '~> 3.2'
  spec.add_development_dependency 'pry'
end
