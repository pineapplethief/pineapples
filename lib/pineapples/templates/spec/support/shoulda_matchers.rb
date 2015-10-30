require 'shoulda/matchers'

# Collection of useful matchers for testing web-apps
# --------------
# Docs:
# https://gist.github.com/kyletcarlson/6234923
# https://github.com/thoughtbot/shoulda-matchers#activemodel-matchers
# http://thoughtbot.github.io/shoulda-matchers/
# http://thoughtbot.github.io/shoulda-matchers/docs/v3.0.0.rc1/
# http://thoughtbot.github.io/shoulda-matchers/docs/v3.0.0.rc1/Shoulda/Matchers/ActiveModel.html
# http://thoughtbot.github.io/shoulda-matchers/docs/v3.0.0.rc1/Shoulda/Matchers/ActiveRecord.html

Shoulda::Matchers.configure do |config|
  config.integrate do |with|
    with.test_framework :rspec

    # Choose one or more libraries:
    # with.library :active_record
    # with.library :active_model
    # with.library :action_controller
    # Or, choose the following (which implies all of the above):
    with.library :rails
  end
end
