require "gds_api/test_helpers/content_item_helpers"
require "gds_api/test_helpers/search"
require_relative "../../test/support/rummager_helpers"

module TransitionLandingPageSteps
  include GdsApi::TestHelpers::ContentItemHelpers
  include RummagerHelpers

  TRANSITION_TAXON_CONTENT_ID = "d6c2de5d-ef90-45d1-82d4-5f2438369eea".freeze
  TRANSITION_TAXON_PATH = "/transition".freeze

  def given_there_is_a_transition_taxon
    stub_content_store_has_item(TRANSITION_TAXON_PATH, content_item)
  end

  def when_i_visit_the_transition_landing_page
    visit TRANSITION_TAXON_PATH
  end

  def then_i_can_see_the_title_section
    assert page.has_selector?("title", text: "Brexit transition", visible: false)
  end

  def then_i_can_see_the_header_section
    assert page.has_selector?(".landing-page__header--with-bg-image h1", text: "Brexit transition:time is running out")
  end

  def then_i_cannot_see_the_get_ready_section
    assert page.has_no_selector?(".gem-c-chevron-banner__link", text: "Check what you need to do if there is no deal")
  end

  def then_i_can_see_the_share_links_section
    assert page.has_selector?(".landing-page__share .gem-c-share-links")
  end

  def then_i_can_see_the_take_action_section
    assert page.has_selector?("h2.govuk-heading-l", text: "Get ready for the UK’s deal with the EU")
    assert page.has_selector?(".gem-c-button", text: "Brexit checker: start now")
  end

  def then_i_can_see_the_buckets_section
    assert page.has_selector?("h2.govuk-heading-l", text: "Changes for businesses and citizens")
  end

  def and_i_can_see_the_explore_topics_section
    assert page.has_selector?("h2.govuk-heading-m", text: "All transition period information")

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
        href: "/search/services?parent=#{CGI.escape(TRANSITION_TAXON_PATH)}&topic=#{TRANSITION_TAXON_CONTENT_ID}",
      )
    end
  end

  def and_ecommerce_tracking_is_setup
    assert page.has_css?(".landing-page__section[data-analytics-ecommerce]")
    assert page.has_css?(".landing-page__section[data-ecommerce-start-index='1']")
    assert page.has_css?(".landing-page__section[data-list-title]")
    assert page.has_css?(".landing-page__section[data-search-query]")
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
      assert page.has_css?("a[data-track-category='SeeAllLinkClicked']", text: section)
      assert page.has_css?("a[data-track-action=\"#{TRANSITION_TAXON_PATH}\"]", text: section)
    end
  end

  def then_the_page_is_not_noindexed
    page.assert_no_selector('meta[name="robots"]', visible: false)
  end

  def and_there_is_metadata
    assert page.has_css?("meta[property='og:title'][content='#{I18n.t('transition_landing_page.meta_title')}']", visible: false)
    assert page.has_css?("meta[name='description'][content='#{I18n.t('transition_landing_page.meta_description')}']", visible: false)
    assert page.has_css?("link[rel='canonical'][href='http://www.example.com/transition']", visible: false)
  end

  def content_item
    GovukSchemas::RandomExample.for_schema(frontend_schema: "taxon") do |item|
      item.merge(
        "base_path" => TRANSITION_TAXON_PATH,
        "content_id" => TRANSITION_TAXON_CONTENT_ID,
        "title" => "Transition",
        "phase" => "live",
        "links" => {},
      )
    end
  end
end
