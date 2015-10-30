require 'email_spec'

# Collection of rspec matchers to test email deliveries.
# --------------
# Docs:
# https://github.com/bmabey/email-spec#rspec-matchers

RSpec.configure do |config|
  config.include EmailSpec::Helpers
  config.include EmailSpec::Matchers

  config.before(:each) do
    # Clear out ActionMailer::Base.deliveries
    reset_mailer
  end

end
