source 'https://rubygems.org'

ruby File.read(".ruby-version").strip

gem 'gds-api-adapters', '~> 52.6'
gem 'govuk_ab_testing', '~> 2.4.1'
gem 'govuk_app_config', '~> 1.5.1'
gem 'govuk_frontend_toolkit', '~> 7.5.0'
gem 'govuk_publishing_components', '~> 9.3.0'
gem 'plek', '~> 2.1.1'
gem 'rails', '5.2.0'
gem 'rinku', require: 'rails_rinku'
gem 'sass-rails', '~> 5.0.3'
gem 'slimmer', '~> 13.0.0'
gem 'uglifier', '~> 4.1.12'

group :test do
  gem 'capybara'
  gem 'cucumber-rails', require: false
  gem 'govuk_schemas', '~> 3.1.0'
  gem 'govuk-content-schema-test-helpers'
  gem 'minitest-spec-rails'
  gem 'mocha'
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
  gem 'timecop'
end
