
RSpec.configure do |config|
  # MUST turn off transactional fixtures since we are using database_cleaner instead
  config.use_transactional_fixtures = false

  # truncation gives cleaner starting state for the database...
  config.before(:suite) do
    DatabaseCleaner.clean_with(:truncation)
  end

  # Transactions are the fastest, each example is wrapped into transaction, which is
  # simply rolled back after example completes. Very fast.
  config.before(:each) do
    DatabaseCleaner.strategy = :transaction
  end

  # Deletion is much faster than truncation on smaller datasets, especially at the
  # beginning of app development. You'd want to use it until you'll have huge
  # datasets to test againt and/or tons of tables with many foreign keys.
  config.before(:each, js: true) do
    DatabaseCleaner.strategy = :deletion
  end

  config.around(:each) do |example|
    DatabaseCleaner.cleaning { example.run }
  end
end
