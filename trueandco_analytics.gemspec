$:.push File.expand_path('../lib', __FILE__)

# Maintain your gem's version:
require "trueandco_analytics/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.executables = s.files.grep(%r{^exe/}) { |f| File.basename(f) }

  s.name        = "trueandco_analytics"
  s.version     = TrueandcoAnalytics::VERSION
  s.authors     = [""]
  s.email       = ["Genom-1990@yandex.ru"]
  s.homepage    = ""
  s.summary     = ""
  s.description = ""
  s.license     = "MIT"

  s.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.md"]

  s.add_dependency 'rails'
  s.add_dependency 'fnv'
  s.add_dependency 'sidekiq'
  s.add_dependency 'redis'
  s.add_dependency 'hiredis'
  s.add_dependency 'redis-namespace'
  s.add_dependency 'ipaddress'
  s.add_dependency 'browser'

  s.add_development_dependency "sqlite3"
  s.add_development_dependency "dotenv-rails"
end
