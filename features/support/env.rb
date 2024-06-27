require_relative "../../spec/test_coverage"
TestCoverage.start

# Duplicated in test_helper.rb
ENV["GOVUK_WEBSITE_ROOT"] = "http://www.test.gov.uk"
ENV["GOVUK_APP_DOMAIN"] = "test.gov.uk"
ENV["RAILS_ENV"] ||= "test"

require "cucumber/rails"
require "slimmer/test"

Cucumber::Rails::Database.autorun_database_cleaner = false

GovukTest.configure

ActionController::Base.allow_rescue = false

Capybara.javascript_driver = :headless_chrome
