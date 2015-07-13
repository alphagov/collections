source 'https://rubygems.org'

gem 'rails', '4.2.2'

gem 'sass-rails', '~> 5.0.3'
gem 'uglifier', '~> 2.7.1'
gem 'govuk_frontend_toolkit', '~> 4.0.1'

gem 'unicorn', '~> 4.9.0'
gem 'airbrake', '~> 4.2.1'
gem 'logstasher', '0.6.2' # 0.6.5+ changes the JSON schema used for events

if ENV['SLIMMER_DEV']
  gem 'slimmer', :path => '../slimmer'
else
  gem 'slimmer', '~> 8.2.1'
end

if ENV['API_DEV']
  gem 'gds-api-adapters', :path => '../gds-api-adapters'
else
  gem 'gds-api-adapters', '~> 20.1.2'
end

gem 'plek', '~> 1.11.0'

group :test do
  gem 'capybara', '~> 2.4.1'
  gem 'poltergeist', '~> 1.6.0'

  gem 'minitest-spec-rails', '~> 5.2.0'
  gem 'mocha', '~> 1.1.0', require: false
  gem 'webmock', '~> 1.21.0', require: false
  gem 'cucumber-rails', '~> 1.4.2', require: false
  gem 'govuk-content-schema-test-helpers', '~> 1.3.0'
  gem 'simplecov', '~> 0.10.0'
  gem 'simplecov-rcov', '~> 0.2.3'
end

group :development, :test do
  gem 'byebug', '~> 5.0.0'
  gem 'jasmine-rails', '~> 0.10.8'
end
