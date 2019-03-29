require_relative "test_helper"

require 'capybara/rails'
require 'slimmer/test'

GovukTest.configure

Capybara.javascript_driver = :headless_chrome

class ActionDispatch::IntegrationTest
  include Capybara::DSL
end
