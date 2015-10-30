# Use Rails-provided test helper methods for testing jobs
# --------------
# Docs:
# http://api.rubyonrails.org/classes/ActiveJob/TestHelper.html

RSpec.configure do |config|
  config.include ActiveJob::TestHelper, type: :job
end
