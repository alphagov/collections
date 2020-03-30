require "gds_api/test_helpers/content_item_helpers"
require "gds_api/test_helpers/search"
require_relative "../../test/support/rummager_helpers"
require_relative "../../test/support/coronavirus_helper"
module CoronavirusLandingPageSteps
  include GdsApi::TestHelpers::ContentItemHelpers
  include RummagerHelpers

  CORONAVIRUS_CONTENT_ID = "774cee22-d896-44c1-a611-e3109cce8eae".freeze
  CORONAVIRUS_PATH = "/coronavirus".freeze

  def given_there_is_a_content_item
    stub_content_store_has_item(CORONAVIRUS_PATH, coronavirus_content_item)
  end

  def when_i_visit_the_coronavirus_landing_page
    visit CORONAVIRUS_PATH
  end

  def then_i_can_see_the_header_section
    assert page.has_selector?(".covid__page-header h1", text: "Coronavirus (COVID-19): what you need to do")
  end

  def then_i_can_see_the_nhs_banner
    assert page.has_selector?(".app-c-header-notice__branding--nhs h2", text: "Do not leave home if you or someone you live with has either")
  end

  def then_i_can_see_the_accordions
    assert page.has_selector?(".govuk-accordion__section-header", text: "How to protect yourself and others")
  end

  def and_i_click_on_an_accordion
    first(".govuk-accordion__section").find(".govuk-accordion__section-button").click
  end

  def then_i_can_see_the_accordions_content
    assert page.has_selector?(".govuk-link", text: "Staying at home if you think you have coronavirus (self-isolating)")
  end
end
