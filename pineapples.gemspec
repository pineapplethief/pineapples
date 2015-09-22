# encoding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'pineapples/version'
require 'date'

Gem::Specification.new do |spec|
  s.required_ruby_version = ">= #{Pineapples::RUBY_VERSION}"

  spec.name        = 'pineapples'
  spec.version     = Pineapples::VERSION
  spec.date        = Date.today.strftime('%Y-%m-%d')
  spec.authors     = ['Alexey Glukhov']
  spec.email       = ['gluhov985@gmail.com']

  spec.summary     = 'Generate a Rails app loaded with must-have gems and best practices'
  spec.description = <<-HERE
Rails app generator based on Suspenders by Thoughtbot and Raygun by Carbon Five modified to fit my own personal needs
  HERE
  spec.homepage    = 'http://github.com/pineapplethief/pineapples'
  spec.license     = 'MIT'

  spec.extra_rdoc_files = %w[README.md LICENSE]
  spec.rdoc_options     = ['--charset=UTF-8']

  # Prevent pushing this gem to RubyGems.org by setting 'allowed_push_host', or
  # delete this section to allow pushing this gem to any host.
  if spec.respond_to?(:metadata)
    spec.metadata['allowed_push_host'] = "TODO: Set to 'http://mygemserver.com'"
  else
    raise 'RubyGems 2.0 or newer is required to protect against public gem pushes.'
  end

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = 'exe'
  spec.executables   = ['pineapples']
  spec.require_paths = ['lib']

  spec.add_dependency 'rails', Pineapples::RAILS_VERSION
  spec.add_dependency 'bundler', '~> 1.10'

  spec.add_development_dependency 'rspec', '~> 3.2'
end
