# frozen_string_literal: true

source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

# Declare your gem's dependencies in sn-foil-rails.gemspec.
# Bundler will treat runtime dependencies like base dependencies, and
# development dependencies will be added by default to the :development group.
gemspec

# Declare any dependencies that are still in development here instead of in
# your gemspec. These might include edge Rails or gems from your path or
# Git. Remember to move these dependencies to your gemspec before releasing
# your gem to rubygems.org.

# To use a debugger
# gem 'byebug', group: [:development, :test]

group :development, :test do
  gem 'activerecord-jdbcsqlite3-adapter', platform: :jruby
  gem 'blueprinter'
  gem 'bundle-audit', '~> 0.1.0'
  gem 'database_cleaner-active_record'
  gem 'factory_bot', '~> 6.0'
  gem 'fasterer', '~> 0.10.0'
  gem 'jdbc-sqlite3', platform: :jruby
  gem 'kaminari'
  gem 'net-smtp'
  gem 'pry-byebug', '~> 3.9', platform: :mri
  gem 'puma'
  gem 'rake', '~> 13.0'
  gem 'rspec-rails', '~> 5.0'
  gem 'rubocop', '1.33'
  gem 'rubocop-performance', '1.14.3'
  gem 'rubocop-rails', '~> 2.14'
  gem 'rubocop-rspec', '2.12.1'
  gem 'sqlite3', platform: :mri
end
