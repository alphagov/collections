require_relative "test_helper"
require_relative "support/content_schema_helpers"

require 'capybara/rails'
require 'slimmer/test'
require 'slimmer/test_helpers/govuk_components'

class ActionDispatch::IntegrationTest
  include Capybara::DSL
  include ContentSchemaHelpers
  include Slimmer::TestHelpers::GovukComponents

  before do
    stub_shared_component_locales
  end
end
