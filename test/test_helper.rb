ENV['RAILS_ENV'] ||= 'test'
require_relative "../config/environment"
require "rails/test_help"
require "database_cleaner/active_record"

class ActiveSupport::TestCase
  # Run tests inside a transaction to avoid leftover data
  setup do
    DatabaseCleaner.strategy = :transaction
    DatabaseCleaner.start
  end

  teardown do
    DatabaseCleaner.clean
  end
end
