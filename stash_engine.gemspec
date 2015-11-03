$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "stash_engine/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "stash_engine"
  s.version     = StashEngine::VERSION
  s.authors     = ["sfisher"]
  s.email       = ["scott.fisher@ucop.edu"]
  s.homepage    = "https://github.com/CDLUC3/stash_engine"  #TODO, modify this section with better info
  s.summary     = "The default application for Stash (dashv2) that is not metadata schema specific"
  s.description = "The default application for Stash (dashv2) that is not metadata schema specific"
  s.license     = "MIT"

  s.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.rdoc"]
  s.test_files = Dir["test/**/*"]

  s.add_dependency "rails", "~> 4.2.4"

  s.add_development_dependency "mysql2"

  s.add_dependency "omniauth", "~> 1.2.2"
  s.add_dependency "omniauth-shibboleth", "~> 1.2.1"
  s.add_dependency "omniauth-google-oauth2", "~> 0.2.9"
  s.add_dependency "omniauth-orcid", "~> 1.0.21"
  # you cannot add specific code repo to gemspec so it must just go in the Gemfile instead if for internal use
end
