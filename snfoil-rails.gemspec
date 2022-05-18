# frozen_string_literal: true

require_relative 'lib/snfoil/rails/version'

Gem::Specification.new do |spec|
  spec.name          = 'snfoil-rails'
  spec.version       = SnFoil::Rails::VERSION
  spec.authors       = ['Matthew Howes', 'Danny Murphy', 'Cliff Campbell']
  spec.email         = ['howeszy@gmail.com', 'dmurph24@gmail.com', 'cliffcampbell@hey.com']

  spec.summary       = 'Snfoil Rails Helpers'
  spec.description   = 'Additional functionality gem for using SnFoil with Rails'
  spec.homepage      = 'https://github.com/limited-effort/snfoil-rails'
  spec.license       = 'Apache-2.0'
  spec.required_ruby_version = '>= 2.7'

  spec.metadata['homepage_uri'] = spec.homepage
  spec.metadata['source_code_uri'] = spec.homepage
  spec.metadata['changelog_uri'] = 'https://github.com/limited-effort/snfoil-rails/blob/main/CHANGELOG.md'
  spec.metadata['rubygems_mfa_required'] = 'true'

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  ignore_list = %r{\A(?:test/|spec/|bin/|features/|Rakefile|\.\w)}
  Dir.chdir(File.expand_path(__dir__)) { `git ls-files -z`.split("\x0").reject { |f| f.match(ignore_list) } }

  spec.add_dependency 'activesupport', '>= 5.2.6'
  spec.add_dependency 'snfoil', '~> 1.0.0'
  spec.add_dependency 'snfoil-controller', '>= 1.0.1'

  spec.add_development_dependency 'blueprinter'
  spec.add_development_dependency 'bundle-audit', '~> 0.1.0'
  spec.add_development_dependency 'database_cleaner-active_record'
  spec.add_development_dependency 'factory_bot', '~> 6.0'
  spec.add_development_dependency 'fasterer', '~> 0.10.0'
  spec.add_development_dependency 'kaminari'
  spec.add_development_dependency 'oj'
  spec.add_development_dependency 'pry-byebug', '~> 3.9'
  spec.add_development_dependency 'puma'
  spec.add_development_dependency 'rails', '~> 6.0'
  spec.add_development_dependency 'rake', '~> 13.0'
  spec.add_development_dependency 'rspec-rails', '~> 5.0'
  spec.add_development_dependency 'rubocop', '~> 1.29'
  spec.add_development_dependency 'rubocop-performance', '~> 1.11'
  spec.add_development_dependency 'rubocop-rails', '~> 2.11'
  spec.add_development_dependency 'rubocop-rspec', '~> 2.4'
  spec.add_development_dependency 'sqlite3'
end
