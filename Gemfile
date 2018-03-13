source 'https://rubygems.org'

ruby File.read(".ruby-version").strip

gem 'gds-api-adapters', '~> 51.4'
gem 'govuk_ab_testing', '~> 2.4.1'
gem 'govuk_app_config', '~> 1.4.0'
gem 'govuk_frontend_toolkit', '~> 7.4.1'
gem 'govuk_navigation_helpers', '9.0.0'
gem 'govuk_publishing_components', '~> 5.5.5'
gem 'plek', '~> 2.1.1'
gem 'rails', '5.1.5'
gem 'sass-rails', '~> 5.0.3'
gem 'slimmer', '~> 12.0.0'
gem 'uglifier', '~> 4.1.6'

group :test do
  gem 'capybara'
  gem 'cucumber-rails', require: false
  gem 'govuk_schemas', '~> 3.1.0'
  gem 'govuk-content-schema-test-helpers'
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
