# -*- encoding: utf-8 -*-
# stub: counter_cache_with_conditions 0.9.2 ruby lib

Gem::Specification.new do |s|
  s.name = "counter_cache_with_conditions".freeze
  s.version = "0.9.2"

  s.required_rubygems_version = Gem::Requirement.new(">= 0".freeze) if s.respond_to? :required_rubygems_version=
  s.require_paths = ["lib".freeze]
  s.authors = ["Sergey Kojin".freeze]
  s.date = "2017-03-10"
  s.description = "Replacement for ActiveRecord belongs_to :counter_cache with ability to specify conditions.".freeze
  s.email = ["sergey.kojin@gmail.com".freeze]
  s.homepage = "https://github.com/skojin/counter_cache_with_conditions".freeze
  s.licenses = ["MIT".freeze]
  s.rubygems_version = "3.0.8".freeze
  s.summary = "ActiveRecord counter_cache with conditions.".freeze

  s.installed_by_version = "3.0.8" if s.respond_to? :installed_by_version

  if s.respond_to? :specification_version then
    s.specification_version = 4

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<activerecord>.freeze, [">= 3.2"])
    else
      s.add_dependency(%q<activerecord>.freeze, [">= 3.2"])
    end
  else
    s.add_dependency(%q<activerecord>.freeze, [">= 3.2"])
  end
end
