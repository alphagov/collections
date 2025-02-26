require "gds_api/test_helpers/content_item_helpers"
require "gds_api/test_helpers/search"
require_relative "../../spec/support/search_api_helpers"

module CoronavirusLandingPageSteps
  include GdsApi::TestHelpers::ContentItemHelpers
  include SearchApiHelpers

  CORONAVIRUS_PATH = "/coronavirus".freeze
  CORONAVIRUS_TAXON_PATH = "/health-and-social-care/covid-19".freeze
  OTHER_SUBTAXON_PATH = "#{CORONAVIRUS_TAXON_PATH}/no-hub-page".freeze

  def given_there_is_a_content_item
    stub_content_store_has_item(CORONAVIRUS_PATH, coronavirus_content_item)
  end

  def and_another_coronavirus_subtaxon
    stub_content_store_has_item(OTHER_SUBTAXON_PATH, other_subtaxon_item)
  end

  def when_i_visit_the_coronavirus_landing_page
    visit CORONAVIRUS_PATH
  end

  def when_i_visit_the_coronavirus_taxon_page
    visit CORONAVIRUS_TAXON_PATH
  end

  def when_i_visit_the_coronavirus_business_taxon
    visit BUSINESS_TAXON_PATH
  end

  def when_i_visit_a_coronavirus_subtaxon_without_a_hub_page
    visit OTHER_SUBTAXON_PATH
  end

  def then_i_am_redirected_to_the_landing_page
    expect(page.current_path).to eq "/coronavirus"
  end

  def then_i_can_see_the_header_section
    expect(page).to have_selector(".covid__page-header h1", text: "Coronavirus (COVID-19)")
  end

  def then_i_can_see_sub_headings_of_accordions
    expect(page).to have_content("accordion sub heading")
  end

  def then_i_can_see_the_page_title(title)
    expect(page).to have_selector(".covid__page-header h1", text: title)
  end

  def then_i_can_see_the_accordions
    expect(page).to have_selector("h2", text: "Guidance and support")
  end

  def and_i_can_see_links_to_statistics
    expect(page).to have_link("Track coronavirus cases in the UK", href: "/government/publications/covid-19-track-coronavirus-cases")
  end

  def and_i_can_see_links_to_search
    expect(page).to have_link("News and communications about COVID-19", href: "/search/all?level_one_taxon=5b7b9532-a775-4bd2-a3aa-6ce380184b6c&content_purpose_supergroup%5B%5D=news_and_communications&order=updated-newest")
    expect(page).to have_link("Guidance and regulation about COVID-19", href: "/search/all?level_one_taxon=5b7b9532-a775-4bd2-a3aa-6ce380184b6c&content_purpose_supergroup%5B%5D=guidance_and_regulation&order=updated-newest")
  end

  def and_i_can_see_business_links_to_search
    expect(page).to have_link("News", href: "/search/news-and-communications?level_one_taxon=495afdb6-47be-4df1-8b38-91c8adb1eefc&topical_events%5B%5D=coronavirus-covid-19-uk-government-response&order=updated-newest")
    expect(page).to have_link("Guidance", href: "/search/all?level_one_taxon=495afdb6-47be-4df1-8b38-91c8adb1eefc&topical_events%5B%5D=coronavirus-covid-19-uk-government-response&order=updated-newest")
  end

  def then_the_special_announcement_schema_is_rendered
    special_announcement_schema = find_schema("SpecialAnnouncement")
    expect(special_announcement_schema["name"]).to eq("Coronavirus (COVID-19): what you need to do")
    expect(special_announcement_schema["diseasePreventionInfo"]).to eq("https://www.nhs.uk/conditions/coronavirus-covid-19/")
    # proves that the schema handles non-existent properties OK
    expect(special_announcement_schema["thisKeyDoesNotExist"]).to be nil
  end

  def and_there_are_metatags
    expect(page).to have_selector("meta[name='description'][content='Find information on coronavirus, including guidance and support.']", visible: false)
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
