
RSpec.configure do |config|
  # MUST turn off transactional fixtures since we are using database_cleaner instead
  config.use_transactional_fixtures = false

  config.before(:suite) do
    DatabaseCleaner.clean_with(:truncation)
  end

  config.before(:each) do
    DatabaseCleaner.strategy = :transaction
  end

  config.before(:each, js: true) do
    DatabaseCleaner.strategy = :deletion
  end

  config.around(:each) do |example|
    DatabaseCleaner.cleaning { example.run }
  end
end
