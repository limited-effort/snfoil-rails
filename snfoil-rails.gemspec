# frozen_string_literal: true

$LOAD_PATH.push File.expand_path('lib', __dir__)

# Maintain your gem's version:
require 'snfoil/rails/version'

# Describe your gem and declare its dependencies:
Gem::Specification.new do |spec|
  spec.name        = 'snfoil-rails'
  spec.version     = SnFoil::Rails::VERSION
  spec.authors     = ['Matthew Howes', 'Danny Murphy', 'Cliff Campbell']
  spec.email       = ['howeszy@gmail.com', 'dmurph24@gmail.com', 'cliffcampbell@hey.com']
  spec.summary     = 'Snfoil Rails Helpers'
  spec.description   = 'Additional functionality gem for using SnFoil with Rails'
  spec.homepage      = 'https://github.com/limited-effort/snfoil-rails'
  spec.license       = 'Apache-2.0'
  spec.required_ruby_version = '>= 2.5.0'

  spec.metadata['homepage_uri'] = spec.homepage
  spec.metadata['source_code_uri'] = spec.homepage
  spec.metadata['changelog_uri'] = 'https://github.com/limited-effort/snfoil-rails/blob/main/CHANGELOG.md'

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  ignore_list = %r{\A(?:test/|spec/|bin/|features/|Rakefile|\.\w)}
  Dir.chdir(File.expand_path(__dir__)) { `git ls-files -z`.split("\x0").reject { |f| f.match(ignore_list) } }

  spec.add_runtime_dependency 'activesupport', '>= 5.2.6'
  spec.add_runtime_dependency 'snfoil', '~> 0.10'
  spec.add_runtime_dependency 'snfoil-controller', '~> 0.10'

  spec.add_development_dependency 'bundler', '~> 2.2'
  spec.add_development_dependency 'database_cleaner-active_record'
  spec.add_development_dependency 'oj'
  spec.add_development_dependency 'pry-byebug', '~> 3.9'
  spec.add_development_dependency 'rails', '5.2.6'
  spec.add_development_dependency 'rake', '~> 13.0'
  spec.add_development_dependency 'rspec-rails', '~> 5.0'
  spec.add_development_dependency 'rubocop', '~> 1.18'
  spec.add_development_dependency 'rubocop-performance', '~> 1.11'
  spec.add_development_dependency 'rubocop-rails', '~> 2.11'
  spec.add_development_dependency 'rubocop-rspec', '~> 2.4'
  spec.add_development_dependency 'sqlite3'
end
