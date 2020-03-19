require "gds_api/test_helpers/content_item_helpers"
require "gds_api/test_helpers/search"
require_relative "../../test/support/rummager_helpers"

module CoronavirusLandingPageSteps
  include GdsApi::TestHelpers::ContentItemHelpers
  include RummagerHelpers

  CORONAVIRUS_PATH = "/coronavirus".freeze

  def when_i_visit_the_coronavirus_landing_page
    visit CORONAVIRUS_PATH
  end

  def then_i_can_see_the_header_section
    assert page.has_selector?(".landing-page__header h1", text: "Coronavirus")
  end

  def then_i_can_see_the_introduction_section
    assert page.has_selector?("h2.govuk-heading-l", text: "Guidance for Coronavirus")
  end
end
