source 'https://rubygems.org'

gem 'rails', '4.2.7.1'

gem 'sass-rails', '~> 5.0.3'
gem 'uglifier', '~> 2.7.1'
gem 'govuk_frontend_toolkit', '~> 4.3.0'

gem 'unicorn', '~> 4.9.0'
gem 'airbrake', '~> 4.3.1'
gem 'appsignal', '~> 2.0'
gem 'logstasher', '0.6.2' # 0.6.5+ changes the JSON schema used for events
gem 'govuk_navigation_helpers', '~> 3.1'
gem 'govuk_ab_testing', '1.0.1'
gem 'statsd-ruby', '1.3.0', require: 'statsd'

if ENV['SLIMMER_DEV']
  gem 'slimmer', path: '../slimmer'
else
  gem 'slimmer', '~> 10.1.3'
end

if ENV['API_DEV']
  gem 'gds-api-adapters', path: '../gds-api-adapters'
else
  gem 'gds-api-adapters', '~> 40.1'
end

gem 'plek', '~> 1.11.0'

group :test do
  gem 'capybara', '~> 2.5.0'
  gem 'poltergeist', '~> 1.7.0'

  gem 'minitest-spec-rails', '~> 5.3.0'
  gem 'mocha', '~> 1.1.0', require: false
  gem 'webmock', '~> 1.21.0', require: false
  gem 'cucumber-rails', '~> 1.4.2', require: false
  gem 'govuk-content-schema-test-helpers', '~> 1.3.0'
  gem 'govuk_schemas', '~> 2.1'
  gem 'simplecov', '~> 0.10.0'
  gem 'simplecov-rcov', '~> 0.2.3'
end

group :development, :test do
  gem 'better_errors'
  gem 'binding_of_caller'
  gem 'pry-byebug'
  gem 'jasmine-rails', '~> 0.12.1'
  gem 'govuk-lint'
end
