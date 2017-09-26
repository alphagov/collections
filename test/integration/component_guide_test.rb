require 'integration_test_helper'
require 'govuk_publishing_components/minitest/component_guide_test'

class ComponentGuideTest < ActionDispatch::IntegrationTest
  include GovukPublishingComponents::Minitest::ComponentGuideTest

  def setup
    WebMock.disable_net_connect!(allow_localhost: true)
    Capybara.current_driver = Capybara.javascript_driver
  end

  def teardown
    Capybara.use_default_driver
  end
end
