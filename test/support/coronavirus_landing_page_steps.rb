require "gds_api/test_helpers/content_item_helpers"
require "gds_api/test_helpers/search"
require_relative "../../test/support/rummager_helpers"
require_relative "../../test/support/coronavirus_helper"
module CoronavirusLandingPageSteps
  include GdsApi::TestHelpers::ContentItemHelpers
  include RummagerHelpers

  CORONAVIRUS_CONTENT_ID = "774cee22-d896-44c1-a611-e3109cce8eae".freeze
  CORONAVIRUS_PATH = "/coronavirus".freeze

  BUSINESS_CONTENT_ID = "09944b84-02ba-4742-a696-9e562fc9b29d".freeze
  BUSINESS_PATH = "/coronavirus/business".freeze

  def given_there_is_a_content_item
    stub_content_store_has_item(CORONAVIRUS_PATH, coronavirus_content_item)
  end

  def given_there_is_a_content_item_with_no_time
    stub_content_store_has_item(CORONAVIRUS_PATH, coronavirus_content_item_with_no_time)
  end

  def given_there_is_a_business_content_item
    stub_content_store_has_item(BUSINESS_PATH, business_content_item)
  end

  def when_i_visit_the_coronavirus_landing_page
    visit CORONAVIRUS_PATH
  end

  def when_i_visit_the_business_landing_page
    visit BUSINESS_PATH
  end

  def then_i_can_see_the_header_section
    assert page.has_selector?(".covid__page-header h1", text: "Coronavirus (COVID-19): what you need to do")
  end

  def then_i_can_see_the_business_header_section
    assert page.has_selector?(".covid__page-header h1", text: "Business support")
  end

  def and_i_can_see_the_business_announcements
    assert page.has_selector?(".covid__page-header-link", text: "High street businesses will receive grants")
  end

  def and_i_can_see_the_live_stream_section
    assert page.has_text?("1st April 2020 at 5:00pm")
  end

  def then_i_can_see_the_live_stream_section_with_no_time
    assert_not page.has_text?("1st April 2020 at")
    assert page.has_text?("1st April 2020")
  end

  def then_i_can_see_the_nhs_banner
    assert page.has_selector?(".app-c-header-notice__branding--nhs h2", text: "Do not leave home if you or someone you live with has either")
  end

  def then_i_can_see_the_accordions
    assert page.has_selector?(".govuk-accordion__section-header", text: "How to protect yourself and others")
  end

  def then_i_can_see_the_business_accordions
    assert page.has_selector?(".govuk-accordion__section-header", text: "Funding and support")
  end

  def and_i_click_on_an_accordion
    first(".govuk-accordion__section").find(".govuk-accordion__section-button").click
  end

  def then_i_can_see_the_accordions_content
    assert page.has_selector?(".govuk-link", text: "Staying at home if you think you have coronavirus (self-isolating)")
  end

  def and_i_can_see_links_to_search
    assert page.has_link?("News", href: "/search/news-and-communications?topical_events%5B%5D=coronavirus-covid-19-uk-government-response")
    assert page.has_link?("Guidance", href: "/search/all?topical_events%5B%5D=coronavirus-covid-19-uk-government-response&order=updated-newest")
  end

  def and_i_can_see_business_links_to_search
    assert page.has_link?("News", href: "/search/news-and-communications?level_one_taxon=495afdb6-47be-4df1-8b38-91c8adb1eefc&topical_events%5B%5D=coronavirus-covid-19-uk-government-response&order=updated-newest")
    assert page.has_link?("Guidance", href: "/search/all?level_one_taxon=495afdb6-47be-4df1-8b38-91c8adb1eefc&topical_events%5B%5D=coronavirus-covid-19-uk-government-response&order=updated-newest")
  end

  def then_the_special_announcement_schema_is_rendered
    special_announcement_schema = find_schema("SpecialAnnouncement")
    assert_equal(special_announcement_schema["headline"], "Coronavirus (COVID-19): what you need to do")
    assert_equal(special_announcement_schema["diseasePreventionInfo"], "https://www.gov.uk/coronavirus")
    # proves that the schema handles non-existent properties OK
    assert_nil(special_announcement_schema["gettingTestedInfo"])
  end

  def and_the_faqpage_schema_is_rendered
    special_announcement_schema = find_schema("FAQPage")
    assert_equal(special_announcement_schema["name"], "Coronavirus (COVID-19): what you need to do")
    assert_equal(special_announcement_schema["description"], "Find out about the government response to coronavirus (COVID-19) and what you need to do.")
  end

  def find_schema(schema_name)
    schema_sections = page.find_all("script[type='application/ld+json']", visible: false)
    schemas = schema_sections.map { |section| JSON.parse(section.text(:all)) }

    schemas.detect { |schema| schema["@type"] == schema_name }
  end
end
