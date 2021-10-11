source "https://rubygems.org"

gem "rails", "6.1.4.1"

gem "dalli"
gem "faraday"
gem "gds-api-adapters"
gem "govspeak"
gem "govuk_ab_testing"
gem "govuk_app_config"
gem "govuk_document_types"
gem "govuk_personalisation"
gem "govuk_publishing_components", git: 'https://github.com/alphagov/govuk_publishing_components.git', branch: 'fix-auditing'
gem "plek"
gem "rinku", require: "rails_rinku"
gem "sassc-rails"
gem "slimmer"
gem "uglifier"

group :test do
  gem "cucumber-rails", require: false
  gem "govuk-content-schema-test-helpers"
  gem "govuk_schemas"
  gem "i18n-coverage"
  gem "mocha"
  gem "rails-controller-testing"
  gem "simplecov"
  gem "simplecov-rcov"
  gem "webdrivers"
  gem "webmock", require: false
end

group :development, :test do
  gem "better_errors"
  gem "binding_of_caller"
  gem "climate_control"
  gem "govuk_test"
  gem "i18n-tasks"
  gem "jasmine"
  gem "jasmine_selenium_runner"
  gem "pact", require: false
  gem "pact_broker-client"
  gem "pry-byebug"
  gem "rails_translation_manager"
  gem "rspec-rails"
  gem "rubocop-govuk"
  gem "timecop"
  gem "unparser"
end
