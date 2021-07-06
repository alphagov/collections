require "gds_api/test_helpers/content_item_helpers"
require "gds_api/test_helpers/search"
require_relative "../../spec/support/search_api_helpers"

module CoronavirusLandingPageSteps
  include GdsApi::TestHelpers::ContentItemHelpers
  include SearchApiHelpers

  CORONAVIRUS_PATH = "/coronavirus".freeze
  BUSINESS_PATH = "/coronavirus/business-support".freeze
  EDUCATION_PATH = "/coronavirus/education".freeze

  CORONAVIRUS_TAXON_PATH = "/coronavirus-taxon".freeze
  BUSINESS_TAXON_PATH = CORONAVIRUS_TAXON_PATH + "/businesses-and-self-employed-people".freeze
  BUSINESS_SUBTAXON_PATH = CORONAVIRUS_TAXON_PATH + "/business-sub-taxon".freeze
  OTHER_SUBTAXON_PATH = "#{CORONAVIRUS_TAXON_PATH}/no-hub-page".freeze

  def given_there_is_a_content_item
    stub_content_store_has_item(CORONAVIRUS_PATH, coronavirus_content_item)
  end

  def given_there_is_a_content_item_with_risk_level_element_enabled
    stub_content_store_has_item(CORONAVIRUS_PATH, coronavirus_content_item_with_risk_level_element_enabled)
  end

  def given_there_is_a_content_item_with_risk_level_element_not_enabled
    stub_content_store_has_item(CORONAVIRUS_PATH, coronavirus_content_item_with_risk_level_element_not_enabled)
  end

  def given_there_is_a_content_item_with_timeline_national_applicability
    stub_content_store_has_item(CORONAVIRUS_PATH, coronavirus_content_item_with_timeline_national_applicability)
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

  def when_i_click_on_wales
    choose "Wales"
  end

  def and_i_submit_my_nation
    click_on "View"
  end

  def then_i_am_redirected_to_the_landing_page
    expect(page.current_path).to eq "/coronavirus"
  end

  def then_i_am_redirected_to_the_business_hub_page
    expect(page.current_path).to eq "/coronavirus/business-support"
  end

  def then_i_can_see_the_header_section
    expect(page).to have_selector(".covid__page-header h1", text: "Coronavirus (COVID-19)")
  end

  def then_i_can_see_the_education_header_section
    expect(page).to have_content("Find out when schools are expected to reopen in Scotland, Wales and Northern Ireland")
  end

  def then_i_cannot_see_the_education_header_section
    expect(page).not_to have_content("Find out when schools are expected to reopen in Scotland, Wales and Northern Ireland")
  end

  def then_i_can_see_the_business_page
    expect(page).to have_title("Coronavirus (COVID-19): Business support")
    then_i_can_see_the_page_title("Business support")
  end

  def then_i_can_see_the_page_title(title)
    expect(page).to have_selector(".covid__page-header h1", text: title)
  end

  def then_i_can_see_the_nhs_banner
    expect(page).to have_selector(".covid__nhs-notice", text: "If you have no symptoms")
  end

  def then_i_can_see_the_timeline
    expect(page).to have_selector("h2", text: "Recent and upcoming changes")

    expect(page).to have_selector(".covid-timeline .gem-c-heading", text: "18 September")
    expect(page).to have_selector(".covid-timeline__item .gem-c-govspeak", text: "If you live, work or travel in the North East, you need to follow different covid rules")

    expect(page).to have_selector(".covid-timeline .gem-c-heading", text: "15 September")
    expect(page).to have_selector(".covid-timeline__item .gem-c-govspeak", text: "If you live, work or visit Bolton, you need to follow different covid rules")

    expect(page).to have_selector(".covid-timeline .gem-c-heading", text: "14 September")
    expect(page).to have_selector(".covid-timeline__item .gem-c-govspeak", text: "People must not meet in groups larger than 6 in England. There are exceptions to this ‘rule of 6’")

    expect(page).to have_selector(".covid-timeline .gem-c-heading", text: "24 July")
    expect(page).to have_selector(".covid-timeline__item .gem-c-govspeak", text: "Face coverings are mandatory in shops")
  end

  def then_i_can_see_the_timeline_for_england
    expect(page).to have_selector("#nation-england:not(.covid-timeline__wrapper--hidden)")
    expect(page).to have_selector(".covid-timeline__wrapper--hidden", count: 3, visible: false)
  end

  def then_i_can_see_the_timeline_for_wales
    expect(page).to have_selector("#nation-wales:not(.covid-timeline__wrapper--hidden)")
    expect(page).to have_selector(".covid-timeline__wrapper--hidden", count: 3, visible: false)
  end

  def then_i_can_see_the_accordions
    expect(page).to have_selector("h2", text: "Guidance and support")
    expect(page).to have_selector(".gem-c-accordion__section-header", text: "How to protect yourself and others")
  end

  def then_i_can_see_the_business_accordions
    expect(page).to have_selector("h2", text: "Guidance and support")
    expect(page).to have_selector(".gem-c-accordion__section-header", text: "Funding and support")
  end

  def then_i_can_see_the_education_accordions
    expect(page).to have_selector("h2", text: "Guidance and support")
    expect(page).to have_selector(".gem-c-accordion__section-header", text: "School curriculum and teaching")
  end

  def and_i_click_on_an_accordion
    first(".gem-c-accordion__section").find(".gem-c-accordion__section-button").click
  end

  def then_i_can_see_the_accordions_content
    expect(page).to have_selector(".govuk-link", text: "Staying at home if you think you have coronavirus (self-isolating)")
  end

  def and_i_can_see_links_to_statistics
    expect(page).to have_link("Track coronavirus cases in the UK", href: "/government/publications/covid-19-track-coronavirus-cases")
  end

  def and_i_can_see_links_to_search
    expect(page).to have_link("News", href: "/search/news-and-communications?topical_events%5B%5D=coronavirus-covid-19-uk-government-response")
    expect(page).to have_link("Guidance", href: "/search/all?topical_events%5B%5D=coronavirus-covid-19-uk-government-response&order=updated-newest")
  end

  def and_i_can_see_business_links_to_search
    expect(page).to have_link("News", href: "/search/news-and-communications?level_one_taxon=495afdb6-47be-4df1-8b38-91c8adb1eefc&topical_events%5B%5D=coronavirus-covid-19-uk-government-response&order=updated-newest")
    expect(page).to have_link("Guidance", href: "/search/all?level_one_taxon=495afdb6-47be-4df1-8b38-91c8adb1eefc&topical_events%5B%5D=coronavirus-covid-19-uk-government-response&order=updated-newest")
  end

  def then_i_can_see_the_risk_level
    expect(page).to have_selector('[data-module="govspeak"]', text: "COVID-19 alert level")
  end

  def then_i_can_not_see_the_risk_level
    expect(page).not_to have_selector('[data-module="govspeak"]', text: "COVID-19 alert level")
  end

  def then_the_special_announcement_schema_is_rendered
    special_announcement_schema = find_schema("SpecialAnnouncement")
    expect(special_announcement_schema["name"]).to eq("Coronavirus (COVID-19): what you need to do")
    expect(special_announcement_schema["diseasePreventionInfo"]).to eq("https://www.gov.uk/coronavirus")
    # proves that the schema handles non-existent properties OK
    expect(special_announcement_schema["gettingTestedInfo"]).to be nil
  end

  def and_there_are_metatags
    expect(page).to have_selector("meta[name='description'][content='Find out about the government response to coronavirus (COVID-19) and what you need to do.']", visible: false)
    expect(page).to have_selector("link[rel='canonical'][href='http://www.example.com/coronavirus']", visible: false)
  end

  def and_the_faqpage_schema_is_rendered
    special_announcement_schema = find_schema("FAQPage")
    expect(special_announcement_schema["name"]).to eq("Coronavirus (COVID-19): what you need to do")
    expect(special_announcement_schema["description"]).to eq("Find out about the government response to coronavirus (COVID-19) and what you need to do.")
  end

  def find_schema(schema_name)
    schema_sections = page.find_all("script[type='application/ld+json']", visible: false)
    schemas = schema_sections.map { |section| JSON.parse(section.text(:all)) }

    schemas.detect { |schema| schema["@type"] == schema_name }
  end
end
