if ENV["USE_SIMPLECOV"]
  require "simplecov"
  require "simplecov-rcov"
  SimpleCov.formatter = SimpleCov::Formatter::RcovFormatter
  SimpleCov.start 'rails'
end

# Duplicated in test_helper.rb
ENV["GOVUK_WEBSITE_ROOT"] = "http://www.test.gov.uk"
ENV["GOVUK_APP_DOMAIN"] = "test.gov.uk"
ENV["GOVUK_ASSET_ROOT"] = "http://static.test.gov.uk"
ENV["RAILS_ENV"] ||= "test"

require 'cucumber/rails'
require_relative 'mocha'
require_relative 'selenium'
require 'slimmer/test'

ActionController::Base.allow_rescue = false

Capybara.javascript_driver = :headless_chrome
