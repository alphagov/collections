source 'https://rubygems.org'

gem 'gds-api-adapters', github: 'alphagov/gds-api-adapters', branch: 'group-sentry-errors'
gem 'govuk_ab_testing', '~> 2.4'
gem 'govuk_app_config', '~> 0.2'
gem 'govuk_frontend_toolkit', '~> 4.3.0'
gem 'govuk_navigation_helpers', '6.3.0'
gem 'logstasher', '0.6.2' # 0.6.5+ changes the JSON schema used for events
gem 'plek', '~> 1.11.0'
gem 'rails', '5.0.5'
gem 'sass-rails', '~> 5.0.3'
gem 'slimmer', '~> 11.0.1'
gem 'uglifier', '~> 2.7.1'
gem 'unicorn', '~> 4.9.0'

group :test do
  gem 'capybara', '~> 2.14.0'
  gem 'cucumber-rails', '~> 1.4.2', require: false
  gem 'govuk_schemas', '~> 2.1'
  gem 'minitest-spec-rails', '~> 5.3.0'
  gem 'mocha', '~> 1.1.0', require: false
  gem 'poltergeist', '~> 1.7.0'
  gem 'simplecov', '~> 0.10.0'
  gem 'simplecov-rcov', '~> 0.2.3'
  gem 'webmock', '~> 1.21.0', require: false
end

group :development, :test do
  gem 'better_errors'
  gem 'binding_of_caller'
  gem 'govuk-lint'
  gem 'jasmine-rails', '~> 0.14.1'
  gem 'pry-byebug'
end
