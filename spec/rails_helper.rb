# frozen_string_literal: true

# Configure Rails Environment
ENV['RAILS_ENV'] = 'test'

require 'rails'

require_relative './spec_helper'
require_relative '../spec/dummy/config/environment'

ActiveRecord::Migrator.migrations_paths = [File.expand_path('../spec/dummy/db/migrate', __dir__)]

require 'rails/test_help'
require 'rspec/rails'
require 'database_cleaner/active_record'
require 'kaminari'

require 'snfoil/rails'

RSpec.configure do |config|
  config.before(:suite) do
    DatabaseCleaner.strategy = :transaction
    DatabaseCleaner.clean_with(:truncation)
  end

  config.around do |example|
    DatabaseCleaner.cleaning do
      example.run
    end
  end
end
