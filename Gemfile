source 'https://rubygems.org'

gem 'rails', '4.2.5.2'

gem 'sass-rails', '~> 5.0.3'
gem 'uglifier', '~> 2.7.1'
gem 'govuk_frontend_toolkit', '~> 4.3.0'

gem 'unicorn', '~> 4.9.0'
gem 'airbrake', '~> 4.3.1'
gem 'logstasher', '0.6.2' # 0.6.5+ changes the JSON schema used for events

if ENV['SLIMMER_DEV']
  gem 'slimmer', :path => '../slimmer'
else
  gem 'slimmer', '9.1.0'
end

if ENV['API_DEV']
  gem 'gds-api-adapters', :path => '../gds-api-adapters'
else
  gem 'gds-api-adapters', '~> 28.2.1'
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
  gem 'simplecov', '~> 0.10.0'
  gem 'simplecov-rcov', '~> 0.2.3'
end

group :development, :test do
  gem 'better_errors'
  gem 'binding_of_caller'
  gem 'pry-byebug'
  gem 'jasmine-rails', '~> 0.12.1'
end
