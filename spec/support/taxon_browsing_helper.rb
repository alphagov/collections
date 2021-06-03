require_relative "../../spec/support/taxon_helpers"
require_relative "../../spec/support/search_api_helpers"
module TaxonBrowsingHelper
  include SearchApiHelpers
  include TaxonHelpers

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
    expect(page.status_code).to eq(500)
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
    set_up_tagged_content
  end

  def and_the_taxon_has_short_tagged_content
    set_up_tagged_content(news_and_communications: {
      content_type: "news_and_communications",
      query_type: "most_recent",
      number_of_docs: 1,
    })
  end

  def set_up_tagged_content(override_config = {})
    content_config = {
      guidance_and_regulation: { content_type: "guidance_and_regulation", query_type: "most_popular" },
      services: { content_type: "services", query_type: "most_popular" },
      news_and_communications: { content_type: "news_and_communications", query_type: "most_recent" },
      policy_and_engagement: { content_type: "policy_and_engagement", query_type: "most_recent" },
      transparency: { content_type: "transparency", query_type: "most_recent" },
      research_and_statistics: { content_type: "research_and_statistics", query_type: "most_recent" },
    }.merge(override_config)

    content_config.each_value do |config|
      stub_document_types_for_supergroup(config[:content_type])

      dummy_content = generate_dummy_search_content(config)
      stub_search_api_response(dummy_content, config)
    end

    stub_organisations_for_taxon(content_id, tagged_organisations)
  end

  def generate_dummy_search_content(content_type:, number_of_docs: 2, **_unused_config)
    generate_search_results(number_of_docs, content_type)
  end

  def stub_search_api_response(dummy_content, content_type:, query_type:, **_unused_config)
    case query_type
    when "most_recent"
      stub_most_recent_content_for_taxon(content_id, dummy_content, filter_content_store_document_type: content_type)
    when "most_popular"
      stub_most_popular_content_for_taxon(content_id, dummy_content, filter_content_store_document_type: content_type)
    end
  end

  def when_i_visit_that_taxon
    visit base_path
  end

  def then_i_can_see_the_title_section
    expect(page).to have_selector("title", text: "Taxon title", visible: false)

    within ".gem-c-breadcrumbs" do
      expect(page).to have_link("Home", href: "/")
    end
  end

  def and_i_can_see_the_email_signup_link
    link_text = I18n.t("shared.get_emails")
    expect(page).to have_link(link_text, href: "/email-signup/?link=#{current_path}")
    expect(page).to have_selector("a[data-track-category='emailAlertLinkClicked']", text: link_text)
    expect(page).to have_selector("a[data-track-action=\"#{current_path}\"]", text: link_text)
    expect(page).to have_selector("a[data-track-label=\"\"]", text: link_text)
  end

  def and_i_cannot_see_an_email_signup_link
    expect(page).not_to have_link(
      "Get emails about this topic",
      href: "/email-signup/?link=#{current_path}",
    )
  end

  def and_i_can_see_the_guidance_and_regulation_section
    expect(page).to have_selector(".gem-c-heading", text: "Guidance")

    tagged_content_for_guidance_and_regulation.each do |item|
      if item["content_store_document_type"] == "guide"
        mainstream_content_list_item_test(item)
      else
        all_other_sections_list_item_test(item)
      end
    end

    expected_link = {
      text: "See more guidance and regulation in this topic",
      url: "/search/guidance-and-regulation?#{finder_query_string}",
    }

    expect(page).to have_link(expected_link[:text], href: expected_link[:url])
  end

  def and_i_can_see_the_services_section
    expect(page).to have_selector(".gem-c-heading", text: "Services")
    tagged_content_for_services.each do |item|
      mainstream_content_list_item_test(item)
    end

    expected_link = {
      text: "See more services in this topic",
      url: "/search/services?#{finder_query_string}",
    }
    expect(page).to have_link(expected_link[:text], href: expected_link[:url])
  end

  def and_i_can_see_the_news_and_communications_section
    expect(page).to have_selector(".gem-c-heading", text: "News")

    tagged_content_for_news_and_communications.each do |item|
      all_other_sections_list_item_test(item)
    end

    expected_link = {
      text: "See more news and communications in this topic",
      url: "/search/news-and-communications?#{finder_query_string}",
    }

    expect(page).to have_link(expected_link[:text], href: expected_link[:url])
  end

  def then_i_can_see_the_short_news_and_communications_section
    expect(page).to have_selector(".gem-c-heading", text: "News")
    expect(page).to have_selector(".taxon-page__featured-item")

    expected_link = {
      text: "See more news and communications in this topic",
      url: "/search/news-and-communications?#{finder_query_string}",
    }

    expect(page).to have_link(expected_link[:text], href: expected_link[:url])
  end

  def and_i_can_see_the_policy_papers_and_consulations_section
    expect(page).to have_selector(".gem-c-heading", text: "Policy")

    tagged_content_for_policy_and_engagement.each do |item|
      all_other_sections_list_item_test(item)
    end

    expected_link = {
      text: "See more policy papers and consultations in this topic",
      url: "/search/policy-papers-and-consultations?#{finder_query_string}",
    }

    expect(page).to have_link(expected_link[:text], href: expected_link[:url])
  end

  def and_i_can_see_the_transparency_and_foi_releases_section
    expect(page).to have_selector(".gem-c-heading", text: "Transparency")

    tagged_content_for_transparency.each do |item|
      all_other_sections_list_item_test(item)
    end

    expected_link = {
      text: "See more transparency and freedom of information releases in this topic",
      url: "/search/transparency-and-freedom-of-information-releases?#{finder_query_string}",
    }

    expect(page).to have_link(expected_link[:text], href: expected_link[:url])
  end

  def and_i_can_see_the_research_and_statistics_section
    expect(page).to have_selector(".gem-c-heading", text: "Research")

    tagged_content_for_research_and_statistics.each do |item|
      all_other_sections_list_item_test(item)
    end

    expected_link = {
      text: "See more research and statistics in this topic",
      url: "/search/research-and-statistics?#{finder_query_string}",
    }

    expect(page).to have_link(expected_link[:text], href: expected_link[:url])
  end

  def mainstream_content_list_item_test(item)
    expect(page).to have_selector(".gem-c-document-list__item-title[href=\"#{item['link']}\"]", text: item["title"])
    expect(page).to have_selector(".gem-c-document-list__item-description", text: item["description"])
    expect(page).not_to have_content(expected_organisations(item))
  end

  def all_other_sections_list_item_test(item)
    expect(page).to have_selector(".gem-c-document-list__item-title[href=\"#{item['link']}\"]", text: item["title"])
    expect(page).to have_selector(".gem-c-document-list__attribute time", text: item["public_updated_at"])
    expect(page).to have_selector(".gem-c-document-list__attribute", text: item["content_store_document_type"].humanize)
    expect(page).to have_content(expected_organisations(item))
  end

  def and_i_can_see_the_organisations_section
    expect(page).to have_content("Organisations")

    tagged_org_with_logo = tagged_organisation_with_logo["value"]["link"]
    expect(page).to have_selector(".gem-c-organisation-logo a[href='#{tagged_org_with_logo}']")

    expect(page).to have_link(
      tagged_organisation["value"]["title"],
      href: tagged_organisation["value"]["link"],
    )
  end

  def and_i_can_see_the_in_page_nav
    expect(page).to have_selector(".gem-c-contents-list__list")
    expect(page).to have_selector(".gem-c-contents-list__link", text: "Services")
    expect(page).to have_selector(".gem-c-contents-list__link", text: "Guidance and regulation")
    expect(page).to have_selector(".gem-c-contents-list__link", text: "News and communications")
    expect(page).to have_selector(".gem-c-contents-list__link", text: "Research and statistics")
    expect(page).to have_selector(".gem-c-contents-list__link", text: "Policy papers and consultations")
    expect(page).to have_selector(".gem-c-contents-list__link", text: "Transparency and freedom of information releases")
    expect(page).to have_selector(".gem-c-contents-list__link", text: "Organisations")
    expect(page).to have_selector(".gem-c-contents-list__link", text: "Explore sub-topics")
  end

  def and_i_can_see_the_sub_topic_side_nav
    expect(page).to have_selector(".taxon-page__sub-topic-sidebar")
    within(".taxon-page__sub-topic-sidebar") do
      expect(page).to have_selector("h2", text: "Sub-topics")
      child_taxons = @content_item["links"]["child_taxons"]

      child_taxons.each_with_index do |child_taxon, index|
        expect(page).to have_link(child_taxon["title"], href: child_taxon["base_path"])
        element = find("a[href='#{child_taxon['base_path']}']")
        expect(element["data-track-category"]).to eq("navGridContentClicked")
        expect(element["data-track-action"]).to eq((index + 1).to_s)
        expect(element["data-track-label"]).to eq(child_taxon["base_path"])
        expect(element["data-track-options"]).to eq("{}")
      end
    end
  end

  def then_page_has_meta_robots
    content = page.find('meta[name="robots"]', visible: false)["content"]

    expect(content).to eq("noindex")
  end

  def then_the_page_is_noindexed
    content = page.find('meta[name="robots"]', visible: false)["content"]

    expect(content).to eq("noindex")
  end

  def then_the_page_is_not_noindexed
    expect(page).not_to have_selector('meta[name="robots"]', visible: false)
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
      expect(page).to have_selector("a[data-track-category='SeeAllLinkClicked']", text: "See more #{section} in this topic")
      expect(page).to have_selector("a[data-track-action=\"/foo\"]", text: "See more #{section} in this topic")
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
        "details" => {},
      )
    end
  end

  def tagged_content
    generate_search_results(5)
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
