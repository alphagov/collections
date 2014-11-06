require 'test_helper'

describe SubcategoriesController do
  describe "GET subcategory with a valid sector tag and subcategory" do
    setup do
      collections_api_has_content_for("/oil-and-gas/wells")

      Collections::Application.config.search_client.stubs(:unified_search).with(
        count: "0",
        filter_specialist_sectors: ["oil-and-gas/wells"],
        facet_organisations: "1000",
      ).returns(
        rummager_has_specialist_sector_organisations(
          "oil-and-gas/wells",
        )
       )
    end

    it "requests the tag from the Content API and assign it" do
      get :show, sector: "oil-and-gas", subcategory: "wells"

      assert_equal "Example title", assigns(:subcategory).title
      assert_equal "example description", assigns(:subcategory).description
    end

    it "requests and assign the artefacts for the tag from the Content API" do
      get :show, sector: "oil-and-gas", subcategory: "wells"

      artefact = assigns(:groups).first.artefact
      assert_equal "Oil rigs", artefact.name
    end

    it "sets the correct slimmer headers" do
      get :show, sector: "oil-and-gas", subcategory: "wells"

      artefact = JSON.parse(response.headers["X-Slimmer-Artefact"])
      primary_tag = artefact["tags"][0]

      assert_equal "/oil-and-gas", primary_tag["content_with_tag"]["web_url"]
      assert_equal "Oil and gas", primary_tag["title"] # lowercase due to the humanisation of slug in test helpers

      assert_equal "specialist-sector", response.headers["X-Slimmer-Format"]
      assert_equal "after:.page-header", response.headers["X-Slimmer-Beta-Label"]
    end

    it "sets expiry headers for 30 minutes" do
      get :show, sector: "oil-and-gas", subcategory: "wells"

      assert_equal "max-age=1800, public",  response.headers["Cache-Control"]
    end

    it "links to the organisations" do
      get :show, sector: "oil-and-gas", subcategory: "wells"

      organisations = assigns(:organisations)
      assert_equal '<a class="organisation-link" ' \
        'href="/government/organisations/department-of-energy-climate-change">' \
        'Department of Energy &amp; Climate Change</a>', \
        organisations.array_of_links.first
    end

    it "returns a 404 status for GET subcategory with an invalid subcategory tag" do
      collections_api_has_no_content_for("/oil-and-gas/coal")
      get :show, sector: "oil-and-gas", subcategory: "coal"

      assert_equal 404, response.status
    end
  end

  describe "invalid slugs" do
    it "returns a cacheable 404 without calling content_api if the sector subcategory slug is invalid" do
      get :show, sector: "oil-and-gas", subcategory: "this & that"

      assert_equal "404", response.code
      assert_equal "max-age=600, public", response.headers["Cache-Control"]
      assert_not_requested(:get, %r{\A#{GdsApi::TestHelpers::ContentApi::CONTENT_API_ENDPOINT}})
    end
  end
end
