ENV['RAILS_ENV'] ||= 'test'

# simple_cov must be enabled before Rails is loaded
require 'spec_helper'

require File.expand_path('../../config/environment', __FILE__)

# Prevent database truncation if the environment is production
abort('The Rails environment is running in production mode!') if Rails.env.production?

require 'rspec/rails'
# Add additional requires below this line. Rails is not loaded until this point!

# The following line is provided for convenience purposes. It has the downside
# of increasing the boot-up time by auto-requiring all files in the support
# directory. Alternatively, in the individual `*_spec.rb` files, manually
# require only the support files necessary.
#
# !! Do not name files in support folder ending with _spec.rb !!
Dir[Rails.root.join('spec/support/*.rb')].each { |file| require file }

# Checks for pending migrations before tests are run.
ActiveRecord::Migration.maintain_test_schema!

RSpec.configure do |config|
  config.include AbstractController::Translation
  config.include Devise::TestHelpers, type: :controller

  config.infer_base_class_for_anonymous_controllers = false
end
