require 'integration_test_helper'

class SpecialistSectorBrowsingTest < ActionDispatch::IntegrationTest

  it "renders a specialist sector tag page and list its sub-categories" do
    subcategories = [
      { slug: "oil-and-gas/wells", title: "Wells", description: "Wells, wells, wells." },
      { slug: "oil-and-gas/fields", title: "Fields", description: "Fields, fields, fields." },
      { slug: "oil-and-gas/offshore", title: "Offshore", description: "Information about offshore oil and gas." },
    ]

    content_api_has_tag("specialist_sector", { slug: "oil-and-gas", title: "Oil and gas", description: "Guidance for the oil and gas industry" })
    content_api_has_sorted_child_tags("specialist_sector", "oil-and-gas", "alphabetical", subcategories)

    visit "/oil-and-gas"
    assert page.has_title?("Oil and gas - GOV.UK")

    within "header.page-header" do
      assert page.has_content?("Oil and gas")
    end

    within ".category-description" do
      assert page.has_content?("Guidance for the oil and gas industry")
    end

    within ".topics ul" do
      within "li:nth-child(1)" do
        assert page.has_link?("Wells")
      end

      within "li:nth-child(2)" do
        assert page.has_link?("Fields")
      end

      within "li:nth-child(3)" do
        assert page.has_link?("Offshore")
      end
    end
  end

  it "renders a specialist sector sub-category and its artefacts" do
    stubbed_response = collections_api_has_curated_lists_for("/oil-and-gas/wells")
    stubbed_response_body = JSON.parse(stubbed_response.response.body)
    example_stubbed_artefact = stubbed_response_body['details']['groups'][0]

    Collections::Application.config.search_client.stubs(:unified_search).with(
      count: "0",
      filter_specialist_sectors: ["oil-and-gas/wells"],
      facet_organisations: "1000",
    ).returns(
      rummager_has_specialist_sector_organisations(
        "oil-and-gas/wells",
      )
    )

    visit "/oil-and-gas/wells"

    assert page.has_title?("Oil and gas: #{stubbed_response_body['title']} - GOV.UK")

    within "header.page-header" do
      assert page.has_content?("Oil and gas")
      assert page.has_content?(stubbed_response_body['title'])
    end

    assert page.has_content?(example_stubbed_artefact['contents'][0]['title'])
  end
end
