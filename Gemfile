source 'https://rubygems.org'

ruby File.read(".ruby-version").strip

gem 'gds-api-adapters', '~> 50.8'
gem 'govuk_ab_testing', '~> 2.4.1'
gem 'govuk_app_config', '~> 0.3'
gem 'govuk_frontend_toolkit', '~> 7.2.0'
gem 'govuk_navigation_helpers', '8.2.0'
gem 'govuk_publishing_components', '~> 3.2.0'
gem 'logstasher', '0.6.2' # 0.6.5+ changes the JSON schema used for events
gem 'plek', '~> 2.0.0'
gem 'rails', '5.1.4'
gem 'sass-rails', '~> 5.0.3'
gem 'slimmer', '~> 11.1.0'
gem 'uglifier', '~> 2.7.1'
gem 'unicorn', '~> 5.4.0'

group :test do
  gem 'capybara'
  gem 'cucumber-rails', require: false
  gem 'govuk_schemas', '~> 2.3.0'
  gem 'minitest-spec-rails'
  gem 'mocha', require: false
  gem 'poltergeist'
  gem 'simplecov'
  gem 'simplecov-rcov'
  gem 'webmock', require: false
end

group :development, :test do
  gem 'better_errors'
  gem 'binding_of_caller'
  gem 'govuk-lint'
  gem 'jasmine-rails'
  gem 'pry-byebug'
end
