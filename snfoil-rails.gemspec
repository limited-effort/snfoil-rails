# frozen_string_literal: true

$LOAD_PATH.push File.expand_path('lib', __dir__)

# Maintain your gem's version:
require 'sn_foil/rails/version'

# Describe your gem and declare its dependencies:
Gem::Specification.new do |spec| # rubocop:disable Metrics/BlockLength
  spec.name        = 'snfoil-rails'
  spec.version     = SnFoil::Rails::VERSION
  spec.authors     = ['Matthew Howes', 'Danny Murphy']
  spec.email       = ['howeszy@gmail.com', 'dmurph24@gmail.com']
  spec.homepage    = 'https://github.com/howeszy/snfoil-rails'
  spec.summary     = 'Additional functionality gem for using SnFoil with Rails'
  spec.license     = 'MIT'

  spec.files = Dir['{lib}/**/*.rb', 'MIT-LICENSE', 'Rakefile', '*.md']

  spec.add_dependency 'activesupport', '>= 5.1'
  spec.add_dependency 'fast_jsonapi', '~> 1.0'
  spec.add_dependency 'rails', '~> 5.1.7'
  spec.add_dependency 'snfoil', '~> 0.3'

  spec.add_development_dependency 'bundler', '~> 2.0'
  spec.add_development_dependency 'pry-byebug', '~> 3.0'
  spec.add_development_dependency 'rake', '~> 13.0'
  spec.add_development_dependency 'rspec-rails', '~> 3.9'
  spec.add_development_dependency 'rubocop', '~> 0.76.0'
  spec.add_development_dependency 'rubocop-rails', '~> 2.0'
  spec.add_development_dependency 'rubocop-rspec', '~> 1.36.0'
  spec.add_development_dependency 'sqlite3'
end
