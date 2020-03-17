require "gds_api/test_helpers/content_item_helpers"
require "gds_api/test_helpers/search"
require_relative "../../test/support/rummager_helpers"

module CoronavirusLandingPageSteps
  include GdsApi::TestHelpers::ContentItemHelpers
  include RummagerHelpers

  CORONAVIRUS_CONTENT_ID = "c4cd0e8a-3ae1-4385-8936-1cfafe5031fb".freeze
  CORONAVIRUS_PATH = "/coronavirus".freeze

  def given_there_is_a_content_item
    stub_content_store_has_item(CORONAVIRUS_PATH, content_item)
  end

  def when_i_visit_the_coronavirus_landing_page
    visit CORONAVIRUS_PATH
  end

  def then_i_can_see_the_header_section
    assert page.has_selector?(".landing-page__header h1", text: "Coronavirus")
  end

  def then_i_can_see_the_introduction_section
    assert page.has_selector?("h2.govuk-heading-l", text: "Guidance for Coronavirus")
  end

  def content_item
    GovukSchemas::RandomExample.for_schema(frontend_schema: "taxon") do |item|
      item.merge(
        "base_path" => CORONAVIRUS_PATH,
        "content_id" => CORONAVIRUS_CONTENT_ID,
        "title" => "Coronavirus",
        "phase" => "live",
        "links" => {},
      )
    end
  end
end
