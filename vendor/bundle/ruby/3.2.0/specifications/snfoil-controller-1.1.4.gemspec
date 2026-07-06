# -*- encoding: utf-8 -*-
# stub: snfoil-controller 1.1.4 ruby lib

Gem::Specification.new do |s|
  s.name = "snfoil-controller".freeze
  s.version = "1.1.4"

  s.required_rubygems_version = Gem::Requirement.new(">= 0".freeze) if s.respond_to? :required_rubygems_version=
  s.metadata = { "changelog_uri" => "https://github.com/limited-effort/snfoil-controller/blob/main/CHANGELOG.md", "homepage_uri" => "https://github.com/limited-effort/snfoil-controller", "rubygems_mfa_required" => "true", "source_code_uri" => "https://github.com/limited-effort/snfoil-controller" } if s.respond_to? :metadata=
  s.require_paths = ["lib".freeze]
  s.authors = ["Matthew Howes".freeze, "Cliff Campbell".freeze]
  s.bindir = "exe".freeze
  s.date = "1980-01-02"
  s.description = "A context-like experience for your controllers".freeze
  s.email = ["matt.howes@limitedeffort.io".freeze, "cliffcampbell@hey.com".freeze]
  s.homepage = "https://github.com/limited-effort/snfoil-controller".freeze
  s.licenses = ["Apache-2.0".freeze]
  s.required_ruby_version = Gem::Requirement.new(">= 3.0".freeze)
  s.rubygems_version = "3.4.20".freeze
  s.summary = "Seperate Display Logic from Business Logic".freeze

  s.installed_by_version = "3.4.20" if s.respond_to? :installed_by_version

  s.specification_version = 4

  s.add_runtime_dependency(%q<activesupport>.freeze, [">= 5.2.6"])
  s.add_runtime_dependency(%q<snfoil-context>.freeze, [">= 1.0.1", "< 2.0"])
end
