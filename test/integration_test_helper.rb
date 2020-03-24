require_relative "test_helper"

require "capybara/rails"
require "slimmer/test"

GovukTest.configure

# Capybara.javascript_driver = :headless_chrome
Capybara.javascript_driver = :selenium_chrome_headless

class ActionDispatch::IntegrationTest
  include Capybara::DSL
end
