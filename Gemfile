source 'https://rubygems.org'

gem 'rails', '4.0.12'

gem 'sass-rails', '4.0.2'
gem 'uglifier', '2.5.0'
gem 'govuk_frontend_toolkit', '1.7.0'
gem 'shared_mustache', '0.1.2'

gem 'unicorn', '4.8.2'
gem 'airbrake', '3.1.15'
gem 'logstasher', '0.5.0'

if ENV['SLIMMER_DEV']
  gem 'slimmer', :path => '../slimmer'
else
  gem 'slimmer', '8.1.0'
end

if ENV['API_DEV']
  gem 'gds-api-adapters', :path => '../gds-api-adapters'
else
  gem 'gds-api-adapters', '16.3.2'
end

gem 'plek', '1.7.0'

group :test do
  gem 'capybara-webkit', '1.1.1'
  gem 'minitest-spec-rails', '4.7.6'
  gem 'mocha', '1.0.0', require: false
  gem 'webmock', '1.17.4', require: false
  gem 'cucumber-rails', "1.4.0", require: false
  gem 'launchy'

  gem 'govuk-content-schema-test-helpers', '~> 1.1.0'
end

group :development, :test do
  gem 'byebug'
  gem 'jasmine-rails'
end
