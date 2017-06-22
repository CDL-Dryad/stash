$LOAD_PATH.push File.expand_path('../lib', __FILE__)

require 'stash_engine/version'

Gem::Specification.new do |s| # rubocop:disable Metrics/BlockLength
  s.name        = 'stash_engine'
  s.version     = StashEngine::VERSION
  s.authors     = ['sfisher']
  s.email       = ['scott.fisher@ucop.edu']
  s.homepage    = 'https://github.com/CDLUC3/stash_engine' # TODO, modify this section with better info
  s.summary     = 'Metadata- and repository-agnostic core Stash functionality'
  s.description = 'Core Stash application functionality independent of repository, metadata schema, or customization'
  s.license     = 'MIT'

  s.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  s.bindir        = 'exe'
  s.executables   = s.files.grep(%r{^exe/}) { |f| File.basename(f) }
  s.require_paths = ['lib']
  s.test_files = Dir['spec/**/*']

  # TODO: remove once we're on Rails 5, probably
  s.add_dependency 'thor', '0.19.1' # hack to get around https://github.com/erikhuda/thor/issues/538

  s.add_dependency 'amoeba', '~> 3.0.0'
  s.add_dependency 'carrierwave', '~> 0.10.0'
  s.add_dependency 'concurrent-ruby', '~> 1.0'
  s.add_dependency 'filesize', '~> 0.1.1'
  s.add_dependency 'font-awesome-rails'
  s.add_dependency 'jquery-fileupload-rails', '~> 0.4.6'
  s.add_dependency 'jquery-rails'
  s.add_dependency 'jquery-turbolinks', '~> 2.1.0'
  s.add_dependency 'jquery-ui-rails'
  s.add_dependency 'kaminari'
  s.add_dependency 'omniauth', '~> 1.6.1'
  s.add_dependency 'omniauth-google-oauth2', '~> 0.2.9'
  s.add_dependency 'omniauth-orcid', '~> 1.0.21'
  s.add_dependency 'omniauth-shibboleth', '~> 1.2.1'
  s.add_dependency 'rails', '~> 4.2.4'
  s.add_dependency 'redcarpet', '~> 3.3'
  s.add_dependency 'wicked_pdf', '~> 1.1.0'
  s.add_dependency 'wkhtmltopdf-binary', '~> 0.12.3.1'
  s.add_dependency 'httpclient', '~> 2.8.3'
  s.add_dependency 'zeroclipboard-rails'

  s.add_development_dependency 'nokogiri', '~> 1.8'
  s.add_development_dependency 'byebug'
  s.add_development_dependency 'database_cleaner', '~> 1.5'
  s.add_development_dependency 'mysql2', '~> 0.3'
  s.add_development_dependency 'rspec', '~> 3.5'
  s.add_development_dependency 'rspec-rails', '~> 3.5'
  s.add_development_dependency 'capybara'
  s.add_development_dependency 'selenium-webdriver'
  s.add_development_dependency 'chromedriver-helper'
  s.add_development_dependency 'rubocop', '~> 0.49'
  s.add_development_dependency 'scss_lint'
  s.add_development_dependency 'simplecov', '~> 0.12'
  s.add_development_dependency 'simplecov-console', '~> 0.3.0'
  # you cannot add specific code repo to gemspec so it must just go in the Gemfile instead if for internal use
end
