require 'test_helper'

describe SubtopicsController do
  describe "GET subtopic with a valid topic and subtopic slug" do
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

    it "sets the correct slimmer headers" do
      get :show, topic_slug: "oil-and-gas", subtopic_slug: "wells"

      artefact = JSON.parse(response.headers["X-Slimmer-Artefact"])
      primary_tag = artefact["tags"][0]
      assert_equal "/oil-and-gas", primary_tag["content_with_tag"]["web_url"]
      assert_equal "Oil and gas", primary_tag["title"] # lowercase due to the humanisation of slug in test helpers
      assert_equal "specialist-sector", response.headers["X-Slimmer-Format"]
    end

    it "sets expiry headers for 30 minutes" do
      get :show, topic_slug: "oil-and-gas", subtopic_slug: "wells"

      assert_equal "max-age=1800, public",  response.headers["Cache-Control"]
    end

    it "returns a 404 status for GET subtopic with an invalid subtopic tag" do
      collections_api_has_no_content_for("/oil-and-gas/coal")

      get :show, topic_slug: "oil-and-gas", subtopic_slug: "coal"

      assert_equal 404, response.status
    end
  end

  describe "invalid slugs" do
    it "returns a cacheable 404 without calling content_api if the subtopic slug is invalid" do
      get :show, topic_slug: "oil-and-gas", subtopic_slug: "this & that"

      assert_equal "404", response.code
      assert_equal "max-age=600, public", response.headers["Cache-Control"]
      assert_not_requested(:get, %r{\A#{GdsApi::TestHelpers::ContentApi::CONTENT_API_ENDPOINT}})
    end
  end
end
