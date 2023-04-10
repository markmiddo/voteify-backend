# -*- encoding: utf-8 -*-
# stub: decent_exposure 3.0.0 ruby lib

Gem::Specification.new do |s|
  s.name = "decent_exposure".freeze
  s.version = "3.0.0"

  s.required_rubygems_version = Gem::Requirement.new(">= 0".freeze) if s.respond_to? :required_rubygems_version=
  s.require_paths = ["lib".freeze]
  s.authors = ["Pavel Pravosud".freeze, "Stephen Caudill".freeze]
  s.date = "2016-07-01"
  s.description = "\n    DecentExposure helps you program to an interface, rather than an\n    implementation in your Rails controllers.  The fact of the matter is that\n    sharing state via instance variables in controllers promotes close coupling\n    with views.  DecentExposure gives you a declarative manner of exposing an\n    interface to the state that controllers contain and thereby decreasing\n    coupling and improving your testability and overall design.\n  ".freeze
  s.email = ["info@hashrocket.com".freeze]
  s.homepage = "https://github.com/hashrocket/decent_exposure".freeze
  s.licenses = ["MIT".freeze]
  s.required_ruby_version = Gem::Requirement.new("~> 2.0".freeze)
  s.rubygems_version = "3.0.8".freeze
  s.summary = "A helper for creating declarative interfaces in controllers".freeze

  s.installed_by_version = "3.0.8" if s.respond_to? :installed_by_version

  if s.respond_to? :specification_version then
    s.specification_version = 4

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<activesupport>.freeze, [">= 4.0"])
      s.add_development_dependency(%q<railties>.freeze, [">= 4.0"])
      s.add_development_dependency(%q<rspec-rails>.freeze, ["~> 3.0"])
    else
      s.add_dependency(%q<activesupport>.freeze, [">= 4.0"])
      s.add_dependency(%q<railties>.freeze, [">= 4.0"])
      s.add_dependency(%q<rspec-rails>.freeze, ["~> 3.0"])
    end
  else
    s.add_dependency(%q<activesupport>.freeze, [">= 4.0"])
    s.add_dependency(%q<railties>.freeze, [">= 4.0"])
    s.add_dependency(%q<rspec-rails>.freeze, ["~> 3.0"])
  end
end
