if ENV['RAILS_ENV'] == 'test' && ENV.fetch('COVERAGE', false)
  require 'simplecov'
  SimpleCov.start 'rails'
end
