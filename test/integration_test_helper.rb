require_relative "test_helper"

require 'capybara/rails'
require 'slimmer/test'
require 'capybara/poltergeist'
require 'phantomjs/poltergeist'

Capybara.javascript_driver = :poltergeist

class ActionDispatch::IntegrationTest
  include Capybara::DSL
end
