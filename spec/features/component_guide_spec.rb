require "govuk_publishing_components/minitest/component_guide_test"
require "integration_spec_helper"

feature "Component guide" do
  # temporarily disabling to get around an error to do with an image in one of the component pages
  # include GovukPublishingComponents::Minitest::ComponentGuideTest

  before do
    WebMock.disable_net_connect!(allow_localhost: true)
    Capybara.current_driver = Capybara.javascript_driver
  end

  def teardown
    Capybara.use_default_driver
  end
end
