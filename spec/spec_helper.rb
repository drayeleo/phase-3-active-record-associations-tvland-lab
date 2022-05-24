ENV["RACK_ENV"] = "test"
require_relative "../config/environment"
require "sinatra/activerecord/rake"

RSpec.configure do |config|
  # Database setup

  ########## begin commented out text ##########

  config.before(:suite) do
    DatabaseCleaner.strategy = :transaction
    DatabaseCleaner.clean_with(:truncation)
  end

  config.around { |example| DatabaseCleaner.cleaning { example.run } }

  ########## end commented out text ##########

  ########## begin insert ##########

  # config.before(:suite) { DatabaseCleaner.clean_with(:truncation) }

  # config.before { DatabaseCleaner.strategy = :transaction }

  # config.before(:each, js: true) { DatabaseCleaner.strategy = :truncation }

  # config.before { DatabaseCleaner.start }

  # config.after { DatabaseCleaner.clean }

  ########## end insert ##########

  config.expect_with :rspec do |expectations|
    expectations.include_chain_clauses_in_custom_matcher_descriptions = true
  end

  config.mock_with :rspec do |mocks|
    mocks.verify_partial_doubles = true
  end

  config.shared_context_metadata_behavior = :apply_to_host_groups
end

def migrate!(direction, version)
  migrations_paths = ActiveRecord::Migrator.migrations_paths
  migrations =
    ActiveRecord::MigrationContext.new(
      migrations_paths,
      ActiveRecord::SchemaMigration
    ).migrations

  ActiveRecord::Migration.suppress_messages do
    ActiveRecord::Migrator.new(
      direction,
      migrations,
      ActiveRecord::SchemaMigration,
      version
    ).migrate
  end
end
