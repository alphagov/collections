require "gds_api/test_helpers/content_item_helpers"
require "gds_api/test_helpers/rummager"
require_relative "../../test/support/rummager_helpers"

module BrexitLandingPageSteps
  include GdsApi::TestHelpers::ContentItemHelpers
  include RummagerHelpers

  def given_there_is_a_brexit_taxon
    content_store_has_item(brexit_taxon_path, content_item)
  end

  def brexit_taxon_path
    "/brexit"
  end

  def content_id
    "d6c2de5d-ef90-45d1-82d4-5f2438369eea"
  end

  def content_item
    GovukSchemas::RandomExample.for_schema(frontend_schema: "taxon") do |item|
      item.merge(
        "base_path" => brexit_taxon_path,
        "content_id" => content_id,
        "title" => "Brexit",
        "phase" => "live",
        "links" => {},
      )
    end
  end

  def when_i_visit_the_brexit_landing_page_with_dynamic_list
    BrexitLandingPageController.any_instance.stubs(:show_dynamic_list?).returns(true)
    visit brexit_taxon_path
  end

  def when_i_visit_the_brexit_landing_page_without_dynamic_list
    BrexitLandingPageController.any_instance.stubs(:show_dynamic_list?).returns(false)
    visit brexit_taxon_path
  end

  def then_i_can_see_the_title_section
    assert page.has_selector?("title", text: "Get ready for Brexit", visible: false)

    within ".gem-c-breadcrumbs" do
      assert page.has_link?("Home", href: "/")
    end
  end

  def then_i_can_see_the_header_section
    assert page.has_selector?(".landing-page__header h1", text: "Get ready for Brexit")
  end

  def then_i_can_see_the_get_ready_section
    assert page.has_selector?(".gem-c-chevron-banner__link", text: "Check what you need to do if there is no deal")
  end

  def then_i_cannot_see_the_get_ready_section
    assert page.has_no_selector?(".gem-c-chevron-banner__link", text: "Check what you need to do if there is no deal")
  end

  def then_i_can_see_the_share_links_section
    assert page.has_selector?(".landing-page__share .gem-c-share-links")
  end

  def then_i_can_see_the_buckets_section
    assert page.has_selector?(".landing-page__section h2", text: "Browse no-deal Brexit guidance")
  end

  def and_i_can_see_an_email_subscription_link
    assert page.has_selector?('a[href="/email-signup/?topic=' + brexit_taxon_path + '"]')
    assert page.has_text?("Sign up for email alerts")
  end

  def and_i_can_see_the_explore_topics_section
    assert page.has_selector?(".gem-c-heading", text: "All Brexit information")

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
        href: "/search/services?parent=%2Fbrexit&topic=d6c2de5d-ef90-45d1-82d4-5f2438369eea",
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
      "Services", "Guidance and regulation", "News and communications",
      "Research and statistics", "Policy papers and consultations",
      "Transparency and freedom of information releases"
    ].each do |section|
      assert page.has_css?("a[data-track-category='SeeAllLinkClicked']", text: section)
      assert page.has_css?("a[data-track-action=\"#{current_path}\"]", text: section)
    end
  end

  def and_the_start_button_is_tracked
    assert page.has_selector?("a[data-track-category='startButtonClicked']")
    assert page.has_selector?("a[data-track-label='Check what you need to do if there is no deal']")
    assert page.has_selector?("a[data-track-action='/get-ready-brexit-check']")
  end

  def and_the_email_link_is_tracked
    assert page.has_css?("a[data-track-category='emailAlertLinkClicked']")
    assert page.has_css?("a[data-track-action=\"#{current_path}\"]")
  end

  def then_the_page_is_not_noindexed
    page.assert_no_selector('meta[name="robots"]', visible: false)
  end
end
