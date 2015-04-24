require_relative "test_helper"
require_relative "support/content_schema_helpers"

require 'capybara/rails'
require 'slimmer/test'

class ActionDispatch::IntegrationTest
  include Capybara::DSL
  include ContentSchemaHelpers
end
