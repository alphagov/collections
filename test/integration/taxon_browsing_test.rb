require "integration_test_helper"
require_relative "../support/taxon_helpers"

class TaxonBrowsingTest < ActionDispatch::IntegrationTest
  include RummagerHelpers
  include TaxonHelpers
  include GovukAbTesting::MinitestHelpers

  it "renders a taxon page for a live taxon" do
    given_there_is_a_taxon_with_children
    and_the_taxon_is_live
    and_the_taxon_has_tagged_content
    when_i_visit_that_taxon
    then_i_can_see_the_title_section
    and_i_can_see_the_email_signup_link
    and_i_can_see_the_services_section
    and_i_can_see_the_guidance_and_regulation_section
    and_i_can_see_the_news_and_communications_section
    and_i_can_see_the_policy_papers_and_consulations_section
    and_i_can_see_the_transparency_and_foi_releases_section
    and_i_can_see_the_research_and_statistics_section
    and_i_can_see_the_organisations_section
    then_the_page_is_noindexed
  end

  it "renders a promoted item when there is only 1 tagged news item" do
    given_there_is_a_taxon_with_children
    and_the_taxon_is_live
    and_the_taxon_has_short_tagged_content
    when_i_visit_that_taxon
    then_i_can_see_the_short_news_and_communications_section
  end

  it "renders a taxon page for a draft taxon" do
    given_there_is_a_taxon_with_children
    and_the_taxon_is_not_live
    and_the_taxon_has_tagged_content
    when_i_visit_that_taxon
    then_the_page_is_noindexed
    and_i_cannot_see_an_email_signup_link
  end

  it "does not show anything but a taxon" do
    given_there_is_a_thing_that_is_not_a_taxon
    when_i_visit_that_thing
    then_there_should_be_an_error
  end

  it "renders an in-page nav" do
    given_there_is_a_taxon_with_children
    and_the_taxon_is_live
    and_the_taxon_has_tagged_content
    when_i_visit_that_taxon
    and_i_can_see_the_in_page_nav
  end

  it "has tracking on all links" do
    given_there_is_a_taxon_with_children
    and_the_taxon_is_live
    and_the_taxon_has_tagged_content
    when_i_visit_that_taxon
    then_all_links_have_tracking_data
  end

private

  def given_there_is_a_thing_that_is_not_a_taxon
    thing = {
      "base_path" => "/not-a-taxon",
      "content_id" => "36dd87da-4973-5490-ab00-72025b1da602",
      "document_type" => "not_a_taxon",
    }

    stub_content_store_has_item("/not-a-taxon", thing)
  end

  def when_i_visit_that_thing
    visit "/not-a-taxon"
  end

  def then_there_should_be_an_error
    assert_equal 500, page.status_code
  end

  def given_there_is_a_taxon_with_children
    child_one_base_path = "#{base_path}/child-1"
    child_two_base_path = "#{base_path}/child-2"

    child_one = {
      "base_path" => child_one_base_path,
      "content_id" => "36dd87da-4973-5490-ab00-72025b1da601",
      "title" => "Child One",
      "phase" => "live",
      "locale" => "en",
    }

    child_two = {
      "base_path" => child_two_base_path,
      "content_id" => "36dd87da-4973-5490-ab00-72025b1da602",
      "title" => "Child Two",
      "phase" => "live",
      "locale" => "en",
    }

    stub_content_store_has_item(child_one_base_path, child_one)
    stub_content_store_has_item(child_two_base_path, child_two)

    stub_content_store_has_item("/content-item-1", content_item_for_base_path("/content-item-1"))

    given_there_is_a_taxon_without_children

    @content_item["links"]["child_taxons"] = [child_one, child_two]
  end

  def given_there_is_a_taxon_without_children
    @content_item = content_item_without_children(base_path, content_id)
  end

  def and_the_taxon_is_live
    @content_item["phase"] = "live"
    stub_content_store_has_item(base_path, @content_item)
  end

  def and_the_taxon_is_not_live
    @content_item["phase"] = "beta"
    stub_content_store_has_item(base_path, @content_item)
  end

  def and_the_taxon_has_tagged_content
    # We still need to stub tagged content because it is used by the sub-topic grid
    stub_content_for_taxon(content_id, tagged_content)
    stub_supergroup_document_types
    stub_guidance_and_regulation
    stub_services
    stub_news_and_communications
    stub_policy_and_engagement
    stub_transparency
    stub_research_and_statistics
    stub_organisations_for_taxon(content_id, tagged_organisations)
  end

  def and_the_taxon_has_short_tagged_content
    stub_supergroup_document_types
    stub_guidance_and_regulation
    stub_services
    stub_news_and_communications(number_of_docs: 1)
    stub_policy_and_engagement
    stub_transparency
    stub_research_and_statistics
    stub_organisations_for_taxon(content_id, tagged_organisations)
  end

  def stub_supergroup_document_types
    stub_document_types_for_supergroup("guidance_and_regulation")
    stub_document_types_for_supergroup("services")
    stub_document_types_for_supergroup("news_and_communications")
    stub_document_types_for_supergroup("policy_and_engagement")
    stub_document_types_for_supergroup("transparency")
    stub_document_types_for_supergroup("research_and_statistics")
  end

  def stub_guidance_and_regulation
    stub_most_popular_content_for_taxon(content_id, tagged_content_for_guidance_and_regulation, filter_content_store_document_type: "guidance_and_regulation")
  end

  def stub_services
    stub_most_popular_content_for_taxon(content_id, tagged_content_for_services, filter_content_store_document_type: "services")
  end

  def stub_news_and_communications(number_of_docs: 2)
    stub_most_recent_content_for_taxon(content_id, tagged_content_for_news_and_communications(number_of_docs: number_of_docs), filter_content_store_document_type: "news_and_communications")
  end

  def stub_policy_and_engagement
    stub_most_recent_content_for_taxon(content_id, tagged_content_for_policy_and_engagement, filter_content_store_document_type: "policy_and_engagement")
  end

  def stub_transparency
    stub_most_recent_content_for_taxon(content_id, tagged_content_for_transparency, filter_content_store_document_type: "transparency")
  end

  def stub_research_and_statistics
    stub_most_recent_content_for_taxon(content_id, tagged_content_for_research_and_statistics, filter_content_store_document_type: "research_and_statistics")
  end

  def when_i_visit_that_taxon
    visit base_path
  end

  def then_i_can_see_the_title_section
    assert page.has_selector?("title", text: "Taxon title", visible: false)

    within ".gem-c-breadcrumbs" do
      assert page.has_link?("Home", href: "/")
    end
  end

  def and_i_can_see_the_email_signup_link
    assert page.has_link?(
      "Sign up for updates to this topic page",
      href: "/email-signup/?topic=#{current_path}",
    )
    assert page.has_css?("a[data-track-category='emailAlertLinkClicked']", text: "Sign up for updates to this topic page")
    assert page.has_css?("a[data-track-action=\"#{current_path}\"]", text: "Sign up for updates to this topic page")
    assert page.has_css?("a[data-track-label=\"\"]", text: "Sign up for updates to this topic page")
  end

  def and_i_cannot_see_an_email_signup_link
    assert_not page.has_link?(
      "Sign up for updates to this topic page",
      href: "/email-signup/?topic=#{current_path}",
    )
  end

  def and_i_can_see_the_guidance_and_regulation_section
    assert page.has_selector?(".gem-c-heading", text: "Guidance")

    tagged_content_for_guidance_and_regulation.each do |item|
      if item["content_store_document_type"] == "guide"
        mainstream_content_list_item_test(item)
      else
        all_other_sections_list_item_test(item)
      end
    end

    expected_link = {
      text: "See more guidance and regulation in this topic",
      url: "/search/guidance-and-regulation?" + finder_query_string,
    }

    assert page.has_link?(expected_link[:text], href: expected_link[:url])
  end

  def and_i_can_see_the_services_section
    assert page.has_selector?(".gem-c-heading", text: "Services")
    tagged_content_for_services.each do |item|
      mainstream_content_list_item_test(item)
    end

    expected_link = {
      text: "See more services in this topic",
      url: "/search/services?" + finder_query_string,
    }
    assert page.has_link?(expected_link[:text], href: expected_link[:url])
  end

  def and_i_can_see_the_news_and_communications_section
    assert page.has_selector?(".gem-c-heading", text: "News")

    tagged_content_for_news_and_communications.each do |item|
      all_other_sections_list_item_test(item)
    end

    expected_link = {
      text: "See more news and communications in this topic",
      url: "/search/news-and-communications?" + finder_query_string,
    }

    assert page.has_link?(expected_link[:text], href: expected_link[:url])
  end

  def then_i_can_see_the_short_news_and_communications_section
    assert page.has_selector?(".gem-c-heading", text: "News")
    assert page.has_selector?(".taxon-page__featured-item")

    expected_link = {
      text: "See more news and communications in this topic",
      url: "/search/news-and-communications?" + finder_query_string,
    }

    assert page.has_link?(expected_link[:text], href: expected_link[:url])
  end

  def and_i_can_see_the_policy_papers_and_consulations_section
    assert page.has_selector?(".gem-c-heading", text: "Policy")

    tagged_content_for_policy_and_engagement.each do |item|
      all_other_sections_list_item_test(item)
    end

    expected_link = {
      text: "See more policy papers and consultations in this topic",
      url: "/search/policy-papers-and-consultations?" + finder_query_string,
    }

    assert page.has_link?(expected_link[:text], href: expected_link[:url])
  end

  def and_i_can_see_the_transparency_and_foi_releases_section
    assert page.has_selector?(".gem-c-heading", text: "Transparency")

    tagged_content_for_transparency.each do |item|
      all_other_sections_list_item_test(item)
    end

    expected_link = {
      text: "See more transparency and freedom of information releases in this topic",
      url: "/search/transparency-and-freedom-of-information-releases?" + finder_query_string,
    }

    assert page.has_link?(expected_link[:text], href: expected_link[:url])
  end

  def and_i_can_see_the_research_and_statistics_section
    assert page.has_selector?(".gem-c-heading", text: "Research")

    tagged_content_for_research_and_statistics.each do |item|
      all_other_sections_list_item_test(item)
    end

    expected_link = {
      text: "See more research and statistics in this topic",
      url: "/search/research-and-statistics?" + finder_query_string,
    }

    assert page.has_link?(expected_link[:text], href: expected_link[:url])
  end

  def mainstream_content_list_item_test(item)
    assert page.has_selector?('.gem-c-document-list__item-title[href="' + item["link"] + '"]', text: item["title"])
    assert page.has_selector?(".gem-c-document-list__item-description", text: item["description"])
    assert page.has_no_content?(expected_organisations(item))
  end

  def all_other_sections_list_item_test(item)
    assert page.has_selector?('.gem-c-document-list__item-title[href="' + item["link"] + '"]', text: item["title"])
    assert page.has_selector?(".gem-c-document-list__attribute time", text: item["public_updated_at"])
    assert page.has_selector?(".gem-c-document-list__attribute", text: item["content_store_document_type"].humanize)
    assert page.has_content?(expected_organisations(item))
  end

  def and_i_can_see_the_organisations_section
    assert page.has_content?("Organisations")

    tagged_org_with_logo = tagged_organisation_with_logo["value"]["link"]
    assert page.has_css?(".gem-c-organisation-logo a[href='#{tagged_org_with_logo}']")

    assert page.has_link?(
      tagged_organisation["value"]["title"],
      href: tagged_organisation["value"]["link"],
    )
  end

  def and_i_can_see_the_in_page_nav
    assert page.has_selector?(".gem-c-contents-list__list")
    assert page.has_selector?(".gem-c-contents-list__link", text: "Services")
    assert page.has_selector?(".gem-c-contents-list__link", text: "Guidance and regulation")
    assert page.has_selector?(".gem-c-contents-list__link", text: "News and communications")
    assert page.has_selector?(".gem-c-contents-list__link", text: "Research and statistics")
    assert page.has_selector?(".gem-c-contents-list__link", text: "Policy papers and consultations")
    assert page.has_selector?(".gem-c-contents-list__link", text: "Transparency and freedom of information releases")
    assert page.has_selector?(".gem-c-contents-list__link", text: "Organisations")
    assert page.has_selector?(".gem-c-contents-list__link", text: "Explore sub-topics")
  end

  def and_i_can_see_the_sub_topic_side_nav
    assert page.has_selector?(".taxon-page__sub-topic-sidebar")
    within(".taxon-page__sub-topic-sidebar") do
      assert page.has_selector?("h2", text: "Sub-topics")
      child_taxons = @content_item["links"]["child_taxons"]

      child_taxons.each_with_index do |child_taxon, index|
        assert page.has_link?(child_taxon["title"], href: child_taxon["base_path"])
        element = find("a[href='#{child_taxon['base_path']}']")
        assert_equal "navGridContentClicked", element["data-track-category"]
        assert_equal (index + 1).to_s, element["data-track-action"]
        assert_equal child_taxon["base_path"], element["data-track-label"]
        assert_equal "{}", element["data-track-options"]
      end
    end
  end

  def then_page_has_meta_robots
    content = page.find('meta[name="robots"]', visible: false)["content"]

    assert_equal(
      "noindex",
      content,
      "The content of the robots meta tag should be 'noindex'",
    )
  end

  def then_the_page_is_noindexed
    content = page.find('meta[name="robots"]', visible: false)["content"]

    assert_equal(
      "noindex",
      content,
      "The content of the robots meta tag should be 'noindex'",
    )
  end

  def then_the_page_is_not_noindexed
    page.assert_no_selector('meta[name="robots"]', visible: false)
  end

  def then_all_links_have_tracking_data
    [
      "services",
      "guidance and regulation",
      "news and communications",
      "research and statistics",
      "policy papers and consultations",
      "transparency and freedom of information releases",
    ].each do |section|
      assert page.has_css?("a[data-track-category='SeeAllLinkClicked']", text: "See more #{section} in this topic")
      assert page.has_css?("a[data-track-action=\"/foo\"]", text: "See more #{section} in this topic")
    end
  end

  def base_path
    "/foo"
  end

  def content_id
    "36dd87da-4973-5490-ab00-72025b1da600"
  end

  def content_item_without_children(base_path, content_id)
    GovukSchemas::RandomExample.for_schema(frontend_schema: "taxon") do |item|
      item.merge(
        "base_path" => base_path,
        "content_id" => content_id,
        "title" => "Taxon title",
        "phase" => "live",
        "links" => {},
      )
    end
  end

  def tagged_content
    generate_search_results(5)
  end

  def taxon
    GovukSchemas::Example.find("taxon", example_name: "taxon").tap do |content_item|
      content_item["phase"] = "live"
    end
  end

  def tagged_content_for_services
    @tagged_content_for_services ||= generate_search_results(2, "services")
  end

  def tagged_content_for_guidance_and_regulation
    @tagged_content_for_guidance_and_regulation ||= generate_search_results(2, "guidance_and_regulation")
  end

  def tagged_content_for_news_and_communications(number_of_docs: 2)
    @tagged_content_for_news_and_communications ||= generate_search_results(number_of_docs, "news_and_communications")
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
      tagged_organisation_with_logo,
    ]
  end

  def tagged_organisation
    {
      "value" => {
        "title" => "Organisation without logo",
        "link" => "/government/organisations/organisation-without-logo",
        "organisation_state" => "live",
      },
    }
  end

  def tagged_organisation_with_logo
    {
      "value" => {
        "title" => "Organisation with logo",
        "link" => "/government/organisations/organisation-with-logo",
        "organisation_state" => "live",
        "organisation_brand" => "org-brand",
        "organisation_crest" => "single-identity",
        "logo_formatted_title" => "organisation-with-logo",
      },
    }
  end

  def finder_query_string
    {
      parent: @content_item["base_path"],
      topic: @content_item["content_id"],
    }.to_query
  end

  def expected_organisations(content)
    content["organisations"]
      .map { |org| org["title"] }
      .to_sentence
  end
end
