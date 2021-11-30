require "gds_api/test_helpers/content_item_helpers"
require "gds_api/test_helpers/search"

module BrexitLandingPageSteps
  include GdsApi::TestHelpers::ContentItemHelpers

  BREXIT_TAXON_CONTENT_ID = "d6c2de5d-ef90-45d1-82d4-5f2438369eea".freeze
  BREXIT_TAXON_PATH = "/brexit".freeze

  def given_there_is_a_brexit_taxon
    stub_content_store_has_item(BREXIT_TAXON_PATH, content_item)
  end

  def when_i_visit_the_brexit_landing_page
    visit BREXIT_TAXON_PATH
  end

  def then_i_can_see_the_title_section
    expect(page).to have_selector("title", text: "Brexit", visible: false)
  end

  def then_i_can_see_the_header_section
    expect(page).to have_selector(".landing-page__header h1", text: "Brexit")
  end

  def then_i_cannot_see_the_get_ready_section
    expect(page).not_to have_selector(".gem-c-chevron-banner__link", text: "Check what you need to do if there is no deal")
  end

  def and_i_can_see_the_explore_topics_section
    expect(page).to have_selector("h2", text: "All Brexit information")

    supergroups = [
      "Services": "services",
      "News and communications": "news-and-communications",
      "Guidance and regulation": "guidance-and-regulation",
      "Research and statistics": "research-and-statistics",
      "Policy and engagement": "policy-and-engagement",
      "Transparency": "transparency",
    ]

    supergroups.each do |_|
      assert page.has_link?(
        "Services",
        href: "/search/services?parent=#{CGI.escape(BREXIT_TAXON_PATH)}&topic=#{BREXIT_TAXON_CONTENT_ID}",
      )
    end
  end

  def then_all_finder_links_have_tracking_data
    [
      "Services",
      "Guidance and regulation",
      "News and communications",
      "Research and statistics",
      "Policy papers and consultations",
      "Transparency and freedom of information releases",
    ].each do |section|
      expect(page).to have_selector("a[data-track-category='brexit-landing-page']", text: section)
      expect(page).to have_selector("a[data-track-action=\"#{section}\"]", text: section)
    end
  end

  def then_the_page_is_not_noindexed
    expect(page).not_to have_selector('meta[name="robots"]', visible: false)
  end

  def and_there_is_metadata
    expect(page).to have_selector("meta[property='og:title'][content='#{I18n.t('brexit_landing_page.meta_title')}']", visible: false)
    expect(page).to have_selector("meta[name='description'][content='#{I18n.t('brexit_landing_page.meta_description')}']", visible: false)
    expect(page).to have_selector("link[rel='canonical'][href='http://www.example.com/brexit']", visible: false)
  end

  def content_item
    GovukSchemas::RandomExample.for_schema(frontend_schema: "taxon") do |item|
      item.merge(
        "base_path" => BREXIT_TAXON_PATH,
        "content_id" => BREXIT_TAXON_CONTENT_ID,
        "title" => "Brexit",
        "phase" => "live",
        "links" => {},
      )
    end
  end

  def and_the_faqpage_schema_is_rendered
    faq_schema = find_schema("FAQPage")
    expect(faq_schema["name"]).to eq("Brexit")
    expect(faq_schema["description"]).to include("Find out how new Brexit rules apply to things like travel and doing business with Europe.")
  end

  def find_schema(schema_name)
    schema_sections = page.find_all("script[type='application/ld+json']", visible: false)
    schemas = schema_sections.map { |section| JSON.parse(section.text(:all)) }

    schemas.detect { |schema| schema["@type"] == schema_name }
  end
end
