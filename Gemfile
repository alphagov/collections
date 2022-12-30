source "https://rubygems.org"

gem "rails", "7.0.4"

gem "dalli"
gem "faraday"
gem "gds-api-adapters"
gem "govspeak"
gem "govuk_ab_testing"
gem "govuk_app_config", github: "alphagov/govuk_app_config", branch: "csp-modernisation"
gem "govuk_document_types"
gem "govuk_publishing_components"
gem "mail", "~> 2.7.1"  # TODO: remove once https://github.com/mikel/mail/issues/1489 is fixed.
gem "plek"
gem "rails-i18n"
gem "rails_translation_manager"
gem "rinku", require: "rails_rinku"
gem "sassc-rails"
gem "slimmer"
gem "sprockets-rails"
gem "uglifier"

group :test do
  gem "cucumber-rails", require: false
  gem "govuk_schemas"
  gem "i18n-coverage"
  gem "mocha"
  gem "rails-controller-testing"
  gem "simplecov"
  gem "simplecov-rcov"
  gem "webmock", require: false
end

group :development do
  gem "better_errors"
end

group :development, :test do
  gem "binding_of_caller"
  gem "climate_control"
  gem "govuk_test"
  gem "pact", require: false
  gem "pact_broker-client"
  gem "pry-byebug"
  gem "rspec-rails"
  gem "rubocop-govuk"
  gem "timecop"
  gem "unparser"
end
