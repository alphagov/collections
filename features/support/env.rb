if ENV["USE_SIMPLECOV"]
  require "simplecov"
  require "simplecov-rcov"
  SimpleCov.formatter = SimpleCov::Formatter::RcovFormatter
  SimpleCov.start 'rails'
end

require 'cucumber/rails'
require 'mocha/mini_test'
require 'slimmer/test'

ActionController::Base.allow_rescue = false

Capybara.javascript_driver = :webkit

Before('@javascript') do
  # Block javascript from loading external URLs like Google Analytics.
  page.driver.block_unknown_urls
end
