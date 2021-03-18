require "gds_api/test_helpers/content_item_helpers"
require "gds_api/test_helpers/search"
require_relative "../../test/support/search_api_helpers"
require_relative "../../test/support/coronavirus_helper"
module CoronavirusLandingPageSteps
  include GdsApi::TestHelpers::ContentItemHelpers
  include SearchApiHelpers

  CORONAVIRUS_PATH = "/coronavirus".freeze
  BUSINESS_PATH = "/coronavirus/business-support".freeze
  EDUCATION_PATH = "/coronavirus/education".freeze

  CORONAVIRUS_TAXON_PATH = "/coronavirus-taxon".freeze
  BUSINESS_TAXON_PATH = CORONAVIRUS_TAXON_PATH + "/businesses-and-self-employed-people".freeze
  BUSINESS_SUBTAXON_PATH = CORONAVIRUS_TAXON_PATH + "/business-sub-taxon".freeze
  OTHER_SUBTAXON_PATH = CORONAVIRUS_TAXON_PATH + "/no-hub-page"

  def given_there_is_a_content_item
    stub_content_store_has_item(CORONAVIRUS_PATH, coronavirus_content_item)
  end

  def given_there_is_a_content_item_with_livestream_disabled
    stub_content_store_has_item(CORONAVIRUS_PATH, coronavirus_content_item_with_livestream_disabled)
  end

  def given_there_is_a_content_item_with_live_stream_time
    stub_content_store_has_item(CORONAVIRUS_PATH, coronavirus_content_item_with_live_stream_time)
  end

  def given_there_is_a_content_item_with_popular_questions_link_disabled
    stub_content_store_has_item(CORONAVIRUS_PATH, content_item_with_popular_questions_link_disabled)
  end

  def given_there_is_a_content_item_with_ask_a_question_disabled
    stub_content_store_has_item(CORONAVIRUS_PATH, content_item_with_ask_a_question_disabled)
  end

  def given_there_is_a_content_item_with_risk_level_element_enabled
    stub_content_store_has_item(CORONAVIRUS_PATH, coronavirus_content_item_with_risk_level_element_enabled)
  end

  def given_there_is_a_content_item_with_risk_level_element_not_enabled
    stub_content_store_has_item(CORONAVIRUS_PATH, coronavirus_content_item_with_risk_level_element_not_enabled)
  end

  def given_there_is_a_business_content_item
    stub_content_store_has_item(BUSINESS_PATH, business_content_item)
  end

  def given_there_is_an_education_content_item
    stub_content_store_has_item(EDUCATION_PATH, education_content_item)
  end

  def and_a_coronavirus_business_taxon
    stub_content_store_has_item(BUSINESS_TAXON_PATH, business_taxon_content_item)
  end

  def and_a_coronavirus_business_subtaxon
    stub_content_store_has_item(BUSINESS_SUBTAXON_PATH, business_subtaxon_content_item)
  end

  def and_another_coronavirus_subtaxon
    stub_content_store_has_item(OTHER_SUBTAXON_PATH, other_subtaxon_item)
  end

  def when_i_visit_the_coronavirus_landing_page
    visit CORONAVIRUS_PATH
  end

  def when_i_visit_the_business_hub_page
    visit BUSINESS_PATH
  end

  def when_i_visit_the_education_hub_page
    visit EDUCATION_PATH
  end

  def when_i_visit_the_coronavirus_taxon_page
    visit CORONAVIRUS_TAXON_PATH
  end

  def when_i_visit_the_coronavirus_business_taxon
    visit BUSINESS_TAXON_PATH
  end

  def when_i_visit_the_coronavirus_business_subtaxon
    visit BUSINESS_SUBTAXON_PATH
  end

  def when_i_visit_a_coronavirus_subtaxon_without_a_hub_page
    visit OTHER_SUBTAXON_PATH
  end

  def then_i_am_redirected_to_the_landing_page
    assert_equal page.current_path, "/coronavirus"
  end

  def then_i_am_redirected_to_the_business_hub_page
    assert_equal page.current_path, "/coronavirus/business-support"
  end

  def then_i_can_see_the_header_section
    assert page.has_selector?(".covid__page-header h1", text: "Coronavirus (COVID-19)")
  end

  def then_i_can_see_the_education_header_section
    assert page.has_text?("Find out when schools are expected to reopen in Scotland, Wales and Northern Ireland")
  end

  def then_i_cannot_see_the_education_header_section
    assert page.has_no_text?("Find out when schools are expected to reopen in Scotland, Wales and Northern Ireland")
  end

  def then_i_can_see_the_business_page
    assert page.has_title?("Coronavirus (COVID-19): Business support")
    then_i_can_see_the_page_title("Business support")
  end

  def then_i_can_see_the_page_title(title)
    assert page.has_selector?(".covid__page-header h1", text: title)
  end

  def then_i_cannot_see_the_live_stream_section
    assert page.has_no_text?("Press conferences and speeches")
  end

  def then_i_can_see_the_live_stream_section_with_streamed_date
    assert page.has_text?("Press conferences and speeches")
    assert page.has_text?("19 April")
    assert_not page.has_text?("19 April at")
  end

  def then_i_can_see_the_live_stream_section_with_date_and_time
    assert page.has_text?("19 April at 5:00pm")
  end

  def then_i_can_see_the_ask_a_question_section
    assert page.has_link?("Ask a question at the next press conference", href: "https://www.gov.uk")
  end

  def then_i_cannot_see_the_ask_a_question_section
    assert page.has_no_link?("Ask a question at the next press conference", href: "https://www.gov.uk")
  end

  def then_i_can_see_the_popular_questions_link
    assert page.has_link?("See the types of questions submitted by the public", href: "https://www.gov.uk")
  end

  def then_i_cannot_see_the_popular_questions_link
    assert page.has_no_link?("See the types of questions submitted by the public", href: "https://www.gov.uk")
  end

  def and_there_is_no_ask_a_question_section
    assert page.has_no_link?("Ask a question at the next press conference")
  end

  def then_i_can_see_the_live_stream_section
    assert page.has_selector?(".covid__topic-wrapper h2", text: "Press conferences and speeches")
    assert page.has_selector?(".covid__video-wrapper")
  end

  def then_i_can_see_the_nhs_banner
    assert page.has_selector?(".app-c-header-notice__branding--nhs h2", text: "Do not leave home if you or someone you live with has either")
  end

  def then_i_can_see_the_timeline
    assert page.has_selector?("h2", text: "Recent and upcoming changes")

    assert page.has_selector?(".covid-timeline .gem-c-heading", text: "18 September")
    assert page.has_selector?(".covid-timeline__item .gem-c-govspeak", text: "If you live, work or travel in the North East, you need to follow different covid rules")

    assert page.has_selector?(".covid-timeline .gem-c-heading", text: "15 September")
    assert page.has_selector?(".covid-timeline__item .gem-c-govspeak", text: "If you live, work or visit Bolton, you need to follow different covid rules")

    assert page.has_selector?(".covid-timeline .gem-c-heading", text: "14 September")
    assert page.has_selector?(".covid-timeline__item .gem-c-govspeak", text: "People must not meet in groups larger than 6 in England. There are exceptions to this ‘rule of 6’")

    assert page.has_selector?(".covid-timeline .gem-c-heading", text: "24 July")
    assert page.has_selector?(".covid-timeline__item .gem-c-govspeak", text: "Face coverings are mandatory in shops")
  end

  def then_i_can_see_the_accordions
    assert page.has_selector?("h2", text: "Guidance and support")
    assert page.has_selector?(".gem-c-accordion__section-header", text: "How to protect yourself and others")
  end

  def then_i_can_see_the_business_accordions
    assert page.has_selector?("h2", text: "Guidance and support")
    assert page.has_selector?(".gem-c-accordion__section-header", text: "Funding and support")
  end

  def then_i_can_see_the_education_accordions
    assert page.has_selector?("h2", text: "Guidance and support")
    assert page.has_selector?(".gem-c-accordion__section-header", text: "School curriculum and teaching")
  end

  def and_i_click_on_an_accordion
    first(".gem-c-accordion__section").find(".gem-c-accordion__section-button").click
  end

  def then_i_can_see_the_accordions_content
    assert page.has_selector?(".govuk-link", text: "Staying at home if you think you have coronavirus (self-isolating)")
  end

  def and_i_can_see_links_to_statistics
    assert page.has_link?("Track coronavirus cases in the UK", href: "/government/publications/covid-19-track-coronavirus-cases")
  end

  def and_i_can_see_links_to_search
    assert page.has_link?("News", href: "/search/news-and-communications?topical_events%5B%5D=coronavirus-covid-19-uk-government-response")
    assert page.has_link?("Guidance", href: "/search/all?topical_events%5B%5D=coronavirus-covid-19-uk-government-response&order=updated-newest")
  end

  def and_i_can_see_business_links_to_search
    assert page.has_link?("News", href: "/search/news-and-communications?level_one_taxon=495afdb6-47be-4df1-8b38-91c8adb1eefc&topical_events%5B%5D=coronavirus-covid-19-uk-government-response&order=updated-newest")
    assert page.has_link?("Guidance", href: "/search/all?level_one_taxon=495afdb6-47be-4df1-8b38-91c8adb1eefc&topical_events%5B%5D=coronavirus-covid-19-uk-government-response&order=updated-newest")
  end

  def then_i_can_see_the_risk_level
    assert page.has_selector?('[data-module="govspeak"]', text: "COVID-19 alert level")
  end

  def then_i_can_not_see_the_risk_level
    assert page.has_no_selector?('[data-module="govspeak"]', text: "COVID-19 alert level")
  end

  def then_the_special_announcement_schema_is_rendered
    special_announcement_schema = find_schema("SpecialAnnouncement")
    assert_equal(special_announcement_schema["name"], "Coronavirus (COVID-19): what you need to do")
    assert_equal(special_announcement_schema["diseasePreventionInfo"], "https://www.gov.uk/coronavirus")
    # proves that the schema handles non-existent properties OK
    assert_nil(special_announcement_schema["gettingTestedInfo"])
  end

  def and_there_are_metatags
    assert page.has_selector? "meta[name='description'][content='Find out about the government response to coronavirus (COVID-19) and what you need to do.']", visible: false
    assert page.has_selector?("link[rel='canonical'][href='http://www.example.com/coronavirus']", visible: false)
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
