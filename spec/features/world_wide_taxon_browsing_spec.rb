require "integration_spec_helper"

RSpec.feature "Worldwide taxon browsing" do
  scenario "renders a leaf page for world content" do
    given_there_is_a_world_wide_country_taxon_without_children
    when_i_visit_that_taxon
    then_i_see_the_taxon_page
    and_i_can_see_the_email_signup_link
    and_i_can_see_the_content_tagged_to_the_taxon
  end

  scenario "renders an accordion page for world content" do
    given_there_is_a_world_wide_country_taxon_with_children
    when_i_visit_that_taxon
    then_i_see_the_taxon_page
    and_i_can_see_the_email_signup_link
    and_i_can_see_links_to_the_child_taxons_in_an_accordion
  end

  def given_there_is_a_world_wide_country_taxon_without_children
    content_item = content_item_without_children(base_path, content_id)

    stub_content_store_has_item(base_path, content_item)
    stub_search_api_tagged_content_request(content_id, tagged_content)
  end

  def given_there_is_a_world_wide_country_taxon_with_children
    child_one_content_id = "36dd87da-4973-5490-ab00-72025b1da601"
    child_two_content_id = "36dd87da-4973-5490-ab00-72025b1da601"

    child_one = {
      "base_path" => "#{base_path}/child-1",
      "content_id" => child_one_content_id,
      "title" => "Child One",
      "phase" => "live",
      "locale" => "en",
    }

    child_two = {
      "base_path" => "#{base_path}/child-2",
      "content_id" => child_two_content_id,
      "title" => "Child Two",
      "phase" => "live",
      "locale" => "en",
    }

    stub_content_store_has_item(child_one_content_id, child_one)
    stub_content_store_has_item(child_one_content_id, child_two)

    @content_item = content_item_without_children(base_path, content_id)

    @content_item["links"]["child_taxons"] = [child_one, child_two]

    stub_content_store_has_item(base_path, @content_item)

    stub_search_api_tagged_content_request(content_id)
    stub_search_api_tagged_content_request(child_one_content_id)
    stub_search_api_tagged_content_request(child_two_content_id)
  end

  def when_i_visit_that_taxon
    visit base_path
  end

  def then_i_see_the_taxon_page
    expect(page).to have_selector("title", text: "Japan", visible: false)
  end

  def and_i_can_see_the_content_tagged_to_the_taxon
    tagged_content.each do |content|
      expect(page).to have_link(content["title"], href: content["link"], class: "govuk-link")
      expect(page.has_css?(".gem-c-document-list__item-description", text: content["description"])).to be(true)
    end
  end

  def and_i_can_see_the_email_signup_link
    expect(page).to have_link("Get emails for this topic")
  end

  def and_i_can_see_links_to_the_child_taxons_in_an_accordion
    child_taxons = @content_item.dig("links", "child_taxons")
    child_taxons.each do |child_taxon|
      expect(page).to have_content(child_taxon["title"])
    end
  end

  def expect_navigation_page_type_tracking(expected_page_type)
    expect(page).to have_selector("meta[name='govuk:navigation-page-type'][content='#{expected_page_type}']", visible: false)
  end

private

  def stub_search_api_tagged_content_request(content_id, search_result = [])
    stub_request(:get, Plek.new.find("search-api") + "/search.json?count=1000&fields%5B%5D=content_store_document_type&fields%5B%5D=description&fields%5B%5D=link&fields%5B%5D=title&filter_taxons%5B%5D=#{content_id}&order=title&start=0")
      .to_return(body: { results: search_result }.to_json)
  end

  def content_item_without_children(base_path, content_id)
    GovukSchemas::RandomExample.for_schema(frontend_schema: "taxon") do |item|
      item.merge(
        "base_path" => base_path,
        "content_id" => content_id,
        "title" => "Japan",
        "phase" => "live",
        "links" => {},
      )
    end
  end

  def base_path
    "/world/japan"
  end

  def content_id
    "36dd87da-4973-5490-ab00-72025b1da600"
  end

  def tagged_content
    [
      {
        "title" => "Hey hello",
        "link" => "hey-hello",
        "description" => "Description for hey hello",
      },
      {
        "title" => "How are you",
        "link" => "how-are-you",
        "description" => "Description for how are you",
      },
    ]
  end
end
