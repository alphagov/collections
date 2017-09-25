require_relative "test_helper"

require 'capybara/rails'
require 'slimmer/test'
require 'slimmer/test_helpers/govuk_components'
require 'capybara/poltergeist'
require 'phantomjs/poltergeist'

Capybara.javascript_driver = :poltergeist

class ActionDispatch::IntegrationTest
  include Capybara::DSL
  include Slimmer::TestHelpers::GovukComponents

  before do
    stub_shared_component_locales
  end
end
