# Loads custom matchers.
# Write custom matcher classes in `spec/matchers/` directory.

Dir[Rails.root.join('spec/support/matchers/**/*.rb')].each { |file| require file }

# Each matcher class will shoule be in a `Matchers` module
# to work with this RSpec configuration.
RSpec.configure do |config|
  config.include Matchers
end
