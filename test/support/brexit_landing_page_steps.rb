require 'gds_api/test_helpers/content_item_helpers'
require 'gds_api/test_helpers/rummager'
require_relative '../../test/support/rummager_helpers'

module BrexitLandingPageSteps
  include GdsApi::TestHelpers::ContentItemHelpers
  include RummagerHelpers

  def given_there_is_a_brexit_taxon
    content_store_has_item(brexit_taxon_path, content_item)
  end

  def brexit_taxon_path
    "/government/brexit"
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
    assert page.has_selector?('title', text: "Get ready for Brexit", visible: false)

    within '.gem-c-breadcrumbs' do
      assert page.has_link?('Home', href: '/')
    end
  end

  def then_i_can_see_the_header_section
    assert page.has_selector?('.landing-page__header h1', text: "Get ready for Brexit")
  end

  def then_i_can_see_the_get_ready_section
    assert page.has_selector?('.landing-page__ready h2', text: "Check if you need to get ready")
  end

  def then_i_cannot_see_the_get_ready_section
    assert page.has_no_selector?('.landing-page__ready h2', text: "Check if you need to get ready")
  end

  def then_i_can_see_the_share_links_section
    assert page.has_selector?('.landing-page__share .gem-c-share-links')
  end

  def then_i_can_see_the_buckets_section
    assert page.has_selector?('.landing-page__section h2', text: "How individuals and families should get ready")
    assert page.has_selector?('.landing-page__section h2', text: "How businesses and organisations should get ready")
    assert page.has_selector?('.landing-page__section h2', text: "How EU nationals living in the UK should get ready")
    assert page.has_selector?('.landing-page__section h2', text: "How UK nationals living in the EU should get ready")
    assert page.has_selector?('.landing-page__section h2', text: "What to do if you receive funding from the EU")

    assert page.has_selector?('.landing-page__section h2 a[href="/prepare-eu-exit"]', text: "How individuals and families should get ready")
    assert page.has_selector?('.landing-page__section-desc', text: "Act now and find out how to get ready if you live in the UK.")
    assert page.has_selector?('.landing-page__section .app-c-taxon-list')
  end

  def and_i_can_see_an_email_subscription_link
    assert page.has_selector?('a[href="/email-signup/?topic=' + brexit_taxon_path + '"]', text: "Subscribe to updates to this topic")
  end

  def and_i_can_see_the_explore_topics_section
    assert page.has_selector?('.gem-c-heading', text: "All Brexit information")

    supergroups = [
      "Services": "services",
      "News and communications": "news-and-communications",
      "Guidance and regulation": "guidance-and-regulation",
      "Research and statistics": "research-and-statistics",
      "Policy and engagement": "policy-and-engagement",
      "Transparency": "transparency"
    ]

    supergroups.each do |_|
      assert page.has_link?(
        'Services',
        href: "/search/services?parent=%2Fgovernment%2Fbrexit&topic=d6c2de5d-ef90-45d1-82d4-5f2438369eea"
      )
    end
  end

  def then_all_finder_links_have_tracking_data
    [
      'Services', 'Guidance and regulation', 'News and communications',
      'Research and statistics', 'Policy papers and consultations',
      'Transparency and freedom of information releases'
    ].each do |section|
      assert page.has_css?("a[data-track-category='SeeAllLinkClicked']", text: section)
      assert page.has_css?("a[data-track-action=\"#{current_path}\"]", text: section)
    end
  end

  def and_bucket_section_headings_are_tracked
    assert_equal(5, page.all(".landing-page__section h2 a[data-track-category='navGridContentClicked']").count)
  end

  def and_the_start_button_is_tracked
    assert page.has_selector?(".gem-c-button[data-track-category='startButtonClicked']", text: "Start now")
    assert page.has_selector?(".gem-c-button[data-track-label='Start now']", text: "Start now")
    assert page.has_selector?(".gem-c-button[data-track-action='#']", text: "Start now")
  end

  def and_the_email_link_is_tracked
    assert page.has_css?("a[data-track-category='emailAlertLinkClicked']", text: "Subscribe to updates to this topic")
    assert page.has_css?("a[data-track-action=\"#{current_path}\"]", text: "Subscribe to updates to this topic")
  end

  def then_the_page_is_not_noindexed
    page.assert_no_selector('meta[name="robots"]', visible: false)
  end
end
