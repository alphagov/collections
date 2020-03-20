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
    assert page.has_selector?(".covid__page-header h1", text: "Coronavirus (COVID-19): what you need to do")
  end

  def then_i_can_see_the_nhs_banner
    assert page.has_selector?(".app-c-header-notice__branding--nhs h2", text: "Stay at home if you or someone you live with have either")
  end

  def then_i_can_see_the_accordians
    assert page.has_selector?(".govuk-accordion__section-header", text: "How to protect yourself and others")
  end

  def and_i_click_on_an_accordian
    first(".govuk-accordion__section").find(".govuk-accordion__section-button").click
  end

  def then_i_can_see_the_accordians_content
    assert page.has_selector?(".govuk-link", text: "Staying at home if you think you have coronavirus (self-isolating)")
  end
end
