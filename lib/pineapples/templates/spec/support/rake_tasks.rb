require 'rake'

# To test rake tasks with rspec
RSpec.configure do |config|
  config.before(:suite) do
    Rails.application.load_tasks
  end
end
