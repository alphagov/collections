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
