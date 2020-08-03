source "https://rubygems.org"

ruby File.read(".ruby-version").strip

gem "dalli"
gem "gds-api-adapters", "~> 67.0.1"
gem "govspeak", "~> 6.5.4"
gem "govuk_ab_testing", "~> 2.4.1"
gem "govuk_app_config", "~> 2.2.1"
gem "govuk_document_types"
gem "govuk_publishing_components", "~> 21.60.1"
gem "plek", "~> 4.0.0"
gem "rails", "5.2.4.3"
gem "rinku", require: "rails_rinku"
gem "sass-rails", "~> 5.0.3"
gem "slimmer", "~> 15.0.0"
gem "uglifier", "~> 4.2.0"

group :test do
  gem "cucumber-rails", require: false
  gem "govuk-content-schema-test-helpers"
  gem "govuk_schemas", "~> 4.1.0"
  gem "govuk_test", "~> 1.0.3"
  gem "minitest-spec-rails"
  gem "mocha"
  gem "rails-controller-testing"
  gem "simplecov"
  gem "simplecov-rcov"
  gem "webmock", require: false
end

group :development, :test do
  gem "better_errors"
  gem "binding_of_caller"
  gem "jasmine-rails"
  gem "pry-byebug"
  gem "rubocop-govuk"
  gem "timecop"
end
