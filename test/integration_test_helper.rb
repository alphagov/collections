require_relative "test_helper"
require 'capybara/rails'
require 'webmock'

WebMock.disable_net_connect!

class ActionDispatch::IntegrationTest
  include Capybara::DSL
end
