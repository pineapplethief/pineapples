require 'bundler/setup'

Bundler.require(:default, :development)

require File.expand_path('../lib/pineapples', __dir__)

Dir['./spec/support/**/*.rb'].each { |file| require file }

RSpec.configure do |config|
  config.include PineapplesTestHelpers

  config.before(:all) do
    create_tmp_directory
    $terminal.indent_size = 2
  end

  config.before(:each) do
    FakeHeroku.clear!
    FakeGithub.clear!
  end

  config.after(:all) do
    remove_app_directory
  end
end
