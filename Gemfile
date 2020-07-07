source "https://rubygems.org"

ruby File.read(".ruby-version").strip

gem "dalli"
gem "gds-api-adapters"
gem "govspeak"
gem "govuk_ab_testing"
gem "govuk_app_config"
gem "govuk_document_types"
gem "govuk_publishing_components"
gem "plek"
gem "rails", "5.2.4.3"
gem "rinku", require: "rails_rinku"
gem "sass-rails"
gem "slimmer"
gem "uglifier"

group :test do
  gem "cucumber-rails", require: false
  gem "govuk-content-schema-test-helpers"
  gem "govuk_schemas"
  gem "govuk_test"
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
