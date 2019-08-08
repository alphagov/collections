require 'gds_api/test_helpers/content_item_helpers'
require 'gds_api/test_helpers/rummager'
require_relative '../../test/support/rummager_helpers'

module BrexitLandingPageSteps
  include GdsApi::TestHelpers::ContentItemHelpers
  include RummagerHelpers

  def given_there_is_a_brexit_taxon
    content_store_has_item(brexit_taxon_path, content_item)
    and_the_taxon_has_tagged_content
  end

  def brexit_taxon_path
    "/government/brexit"
  end

  def content_id
    "d6c2de5d-ef90-45d1-82d4-5f2438369eea"
  end

  def content_item
    @content_item ||= begin
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
  end

  def when_i_visit_the_brexit_landing_page
    visit brexit_taxon_path
  end

  def and_the_taxon_has_tagged_content
    # We still need to stub tagged content because it is used by the sub-topic grid
    stub_content_for_taxon(content_id, tagged_content)
    stub_document_types_for_supergroup('guidance_and_regulation')
    stub_most_popular_content_for_taxon(content_id, tagged_content_for_guidance_and_regulation, filter_content_store_document_type: 'guidance_and_regulation')
    stub_document_types_for_supergroup('services')
    stub_most_popular_content_for_taxon(content_id, tagged_content_for_services, filter_content_store_document_type: 'services')
    stub_document_types_for_supergroup('news_and_communications')
    stub_most_recent_content_for_taxon(content_id, tagged_content_for_news_and_communications, filter_content_store_document_type: 'news_and_communications')
    stub_document_types_for_supergroup('policy_and_engagement')
    stub_most_recent_content_for_taxon(content_id, tagged_content_for_policy_and_engagement, filter_content_store_document_type: 'policy_and_engagement')
    stub_document_types_for_supergroup('transparency')
    stub_most_recent_content_for_taxon(content_id, tagged_content_for_transparency, filter_content_store_document_type: 'transparency')
    stub_document_types_for_supergroup('research_and_statistics')
    stub_most_recent_content_for_taxon(content_id, tagged_content_for_research_and_statistics, filter_content_store_document_type: 'research_and_statistics')
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

  def then_i_can_see_the_share_links_section
    assert page.has_selector?('.landing-page__share .gem-c-share-links')
  end

  def then_i_can_see_the_buckets_section
    assert page.has_selector?('.landing-page__section h2', text: "How individuals and families should get ready")
    assert page.has_selector?('.landing-page__section h2', text: "How businesses and organisations should get ready")
    assert page.has_selector?('.landing-page__section h2', text: "How EU nationals living in the UK should get ready")
    assert page.has_selector?('.landing-page__section h2', text: "How UK nationals living in the EU should get ready")
    assert page.has_selector?('.landing-page__section h2', text: "Prepare for Brexit if you receive EU funding")

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
    assert_equal(page.all(".landing-page__section h2 a[data-track-category='navGridContentClicked']").count, 4)
  end

  def and_the_email_link_is_tracked
    assert page.has_css?("a[data-track-category='emailAlertLinkClicked']", text: "Subscribe to updates to this topic")
    assert page.has_css?("a[data-track-action=\"#{current_path}\"]", text: "Subscribe to updates to this topic")
  end

  def tagged_content
    generate_search_results(5)
  end

  def tagged_content_for_services
    @tagged_content_for_services ||= generate_search_results(2, "services")
  end

  def tagged_content_for_guidance_and_regulation
    @tagged_content_for_guidance_and_regulation ||= generate_search_results(2, 'guidance_and_regulation')
  end

  def tagged_content_for_news_and_communications
    @tagged_content_for_news_and_communications ||= generate_search_results(2, "news_and_communications")
  end

  def tagged_content_for_policy_and_engagement
    @tagged_content_for_policy_and_engagement ||= generate_search_results(2, "policy_and_engagement")
  end

  def tagged_content_for_transparency
    @tagged_content_for_transparency ||= generate_search_results(2, "transparency")
  end

  def tagged_content_for_research_and_statistics
    @tagged_content_for_research_and_statistics ||= generate_search_results(2, "research_and_statistics")
  end

  def finder_query_string
    {
      parent: content_item['base_path'],
      topic: content_item['content_id'],
    }.to_query
  end
end
