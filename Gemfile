source "https://rubygems.org"

ruby "~> 3.2.0"

gem "rails", "7.1.1"

gem "bootsnap", require: false
gem "dalli"
gem "dartsass-rails"
gem "faraday"
gem "gds-api-adapters"
gem "govspeak"
gem "govuk_ab_testing"
gem "govuk_app_config"
gem "govuk_document_types"
gem "govuk_publishing_components", git: "https://github.com/alphagov/govuk_publishing_components.git", branch: "dart-sass-test"
gem "plek"
gem "rails-i18n"
gem "rails_translation_manager"
gem "rinku", require: "rails_rinku"
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
  gem "erb_lint"
  gem "govuk_test"
  gem "pact", require: false
  gem "pact_broker-client"
  gem "pry-byebug"
  gem "rspec-rails"
  gem "rubocop-govuk"
  gem "timecop"
  gem "unparser"
end
