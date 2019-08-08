require 'gds_api/test_helpers/content_item_helpers'

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
    stub_organisations_for_taxon(content_id, tagged_organisations)
  end

  def then_i_can_see_the_title_section
    assert page.has_selector?('title', text: content_item['title'], visible: false)

    within '.gem-c-breadcrumbs' do
      assert page.has_link?('Home', href: '/')
    end
  end

  def and_i_can_see_the_email_signup_link
    assert page.has_link?(
      'Sign up for updates to this topic page',
      href: "/email-signup/?topic=#{current_path}"
    )
    assert page.has_css?("a[data-track-category='emailAlertLinkClicked']", text: "Sign up for updates to this topic page")
    assert page.has_css?("a[data-track-action=\"#{current_path}\"]", text: "Sign up for updates to this topic page")
    assert page.has_css?("a[data-track-label=\"\"]", text: "Sign up for updates to this topic page")
  end

  def and_i_can_see_the_guidance_and_regulation_section
    assert page.has_selector?('.gem-c-heading', text: "Guidance")

    tagged_content_for_guidance_and_regulation.each do |item|
      if item['content_store_document_type'] == 'guide'
        mainstream_content_list_item_test(item)
      else
        all_other_sections_list_item_test(item)
      end
    end

    expected_link = {
      text: "See more guidance and regulation in this topic",
      url: "/search/guidance-and-regulation?" + finder_query_string
    }

    assert page.has_link?(expected_link[:text], href: expected_link[:url])
  end

  def and_i_can_see_the_services_section
    assert page.has_selector?('.gem-c-heading', text: "Services")
    tagged_content_for_services.each do |item|
      mainstream_content_list_item_test(item)
    end

    expected_link = {
      text: "See more services in this topic",
      url: "/search/services?" + finder_query_string
    }
    assert page.has_link?(expected_link[:text], href: expected_link[:url])
  end

  def and_i_can_see_the_news_and_communications_section
    assert page.has_selector?('.gem-c-heading', text: "News")
    assert page.has_selector?('.taxon-page__featured-item')

    tagged_content_for_news_and_communications.each do |item|
      all_other_sections_list_item_test(item)
    end

    expected_link = {
      text: "See more news and communications in this topic",
      url: "/search/news-and-communications?" + finder_query_string
    }

    assert page.has_link?(expected_link[:text], href: expected_link[:url])
  end

  def and_i_can_see_the_policy_papers_and_consulations_section
    assert page.has_selector?('.gem-c-heading', text: "Policy")

    tagged_content_for_policy_and_engagement.each do |item|
      all_other_sections_list_item_test(item)
    end

    expected_link = {
      text: "See more policy papers and consultations in this topic",
      url: "/search/policy-papers-and-consultations?" + finder_query_string
    }

    assert page.has_link?(expected_link[:text], href: expected_link[:url])
  end

  def and_i_can_see_the_transparency_and_foi_releases_section
    assert page.has_selector?('.gem-c-heading', text: "Transparency")

    tagged_content_for_transparency.each do |item|
      all_other_sections_list_item_test(item)
    end

    expected_link = {
      text: "See more transparency and freedom of information releases in this topic",
      url: "/search/transparency-and-freedom-of-information-releases?" + finder_query_string
    }

    assert page.has_link?(expected_link[:text], href: expected_link[:url])
  end

  def and_i_can_see_the_research_and_statistics_section
    assert page.has_selector?('.gem-c-heading', text: "Research")

    tagged_content_for_research_and_statistics.each do |item|
      all_other_sections_list_item_test(item)
    end

    expected_link = {
      text: "See more research and statistics in this topic",
      url: "/search/research-and-statistics?" + finder_query_string
    }

    assert page.has_link?(expected_link[:text], href: expected_link[:url])
  end

  def mainstream_content_list_item_test(item)
    assert page.has_selector?('.gem-c-document-list__item-title[href="' + item["link"] + '"]', text: item["title"])
    assert page.has_selector?('.gem-c-document-list__item-description', text: item["description"])
    assert page.has_no_content?(expected_organisations(item))
  end

  def all_other_sections_list_item_test(item)
    assert page.has_selector?('.gem-c-document-list__item-title[href="' + item["link"] + '"]', text: item["title"])
    assert page.has_selector?('.gem-c-document-list__attribute time', text: item["public_updated_at"])
    assert page.has_selector?('.gem-c-document-list__attribute', text: item["content_store_document_type"].humanize)
    assert page.has_content?(expected_organisations(item))
  end

  def and_i_can_see_the_organisations_section
    assert page.has_content?('Organisations')

    tagged_org_with_logo = tagged_organisation_with_logo['value']['link']
    assert page.has_css?(".gem-c-organisation-logo a[href='#{tagged_org_with_logo}']")

    assert page.has_link?(tagged_organisation['value']['title'],
                          href: tagged_organisation['value']['link'])
  end

  def and_i_can_see_the_in_page_nav
    assert page.has_selector?('.gem-c-contents-list__list')
    assert page.has_selector?('.gem-c-contents-list__link', text: "Services")
    assert page.has_selector?('.gem-c-contents-list__link', text: "Guidance and regulation")
    assert page.has_selector?('.gem-c-contents-list__link', text: "News and communications")
    assert page.has_selector?('.gem-c-contents-list__link', text: "Research and statistics")
    assert page.has_selector?('.gem-c-contents-list__link', text: "Policy papers and consultations")
    assert page.has_selector?('.gem-c-contents-list__link', text: "Transparency and freedom of information releases")
    assert page.has_selector?('.gem-c-contents-list__link', text: "Organisations")
  end

  def then_i_can_see_navigation_to_brexit_pages
    page.assert_selector("h2.gem-c-heading", text: "Prepare for Brexit")
    page.assert_selector("a[href='/business-uk-leaving-eu']", text: "Prepare your business or organisation for Brexit")
  end

  def then_all_links_have_tracking_data
    [
      'services', 'guidance and regulation', 'news and communications',
      'research and statistics', 'policy papers and consultations',
      'transparency and freedom of information releases'
    ].each do |section|
      assert page.has_css?("a[data-track-category='SeeAllLinkClicked']", text: "See more #{section} in this topic")
      assert page.has_css?("a[data-track-action=\"#{current_path}\"]", text: "See more #{section} in this topic")
    end
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

  def tagged_organisations
    [
        tagged_organisation,
        tagged_organisation_with_logo
    ]
  end

  def tagged_organisation
    {
        'value' => {
            'title' => 'Organisation without logo',
            'link' => '/government/organisations/organisation-without-logo',
            'organisation_state' => 'live'
        }
    }
  end

  def tagged_organisation_with_logo
    {
        'value' => {
            'title' => 'Organisation with logo',
            'link' => '/government/organisations/organisation-with-logo',
            'organisation_state' => 'live',
            'organisation_brand' => 'org-brand',
            'organisation_crest' => 'single-identity',
            'logo_formatted_title' => "organisation-with-logo"
        }
    }
  end

  def finder_query_string
    {
      parent: content_item['base_path'],
      topic: content_item['content_id'],
    }.to_query
  end

  def expected_organisations(content)
    content['organisations']
      .map { |org| org['title'] }
      .to_sentence
  end
end
