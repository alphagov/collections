require_relative "spec_helper"

require "capybara/rails"
require "slimmer/test"

GovukTest.configure

Capybara.javascript_driver = :headless_chrome

GovukAbTesting.configure do |config|
  config.acceptance_test_framework = :capybara
end

class ActionDispatch::IntegrationTest
  include Capybara::DSL
end
