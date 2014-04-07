require_relative "test_helper"

require 'capybara/rails'
require 'slimmer/test'

class ActionDispatch::IntegrationTest
  include Capybara::DSL
end
