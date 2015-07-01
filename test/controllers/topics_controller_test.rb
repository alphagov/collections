require_relative '../test_helper'

describe TopicsController do
  include ContentSchemaHelpers

  describe "GET topic" do
    describe "with a valid topic slug" do
      before do
        content_store_has_item('/topic/oil-and-gas', content_schema_example(:topic, :topic))
      end

      it "sets the correct slimmer headers" do
        get :topic, topic_slug: "oil-and-gas"

        assert_equal "specialist-sector", response.headers["X-Slimmer-Format"]
      end

      it "sets expiry headers for 30 minutes" do
        get :topic, topic_slug: "oil-and-gas"

        assert_equal "max-age=1800, public",  response.headers["Cache-Control"]
      end
    end

    it "returns a 404 status for GET topic with an invalid sector tag" do
      content_store_does_not_have_item("/topic/oil-and-gas")
      get :topic, topic_slug: "oil-and-gas"

      assert_equal 404, response.status
    end

    describe "invalid slugs" do
      it "returns a cacheable 404 without calling content-store if the sector slug is invalid" do
        get :topic, topic_slug: "this & that"

        assert_equal "404", response.code
        assert_equal "max-age=600, public",  response.headers["Cache-Control"]
        assert_not_requested(:get, %r{\A#{GdsApi::TestHelpers::ContentStore::CONTENT_STORE_ENDPOINT}})
      end
    end
  end

  describe "GET subtopic" do
    describe "with a valid topic and subtopic slug" do
      setup do
        content_store_has_item(
          "/topic/oil-and-gas/wells",
          content_item_for_base_path("/oil-and-gas/wells").merge({
            "links" => {
              "parent" => [{
                "title" => "Oil and Gas",
                "base_path" => "/oil-and-gas",
              }],
            },
          }),
        )
        content_api_has_artefacts_with_a_tag('specialist_sector', 'oil-and-gas/wells', [])

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
        get :subtopic, topic_slug: "oil-and-gas", subtopic_slug: "wells"

        artefact = JSON.parse(response.headers["X-Slimmer-Artefact"])
        primary_tag = artefact["tags"][0]
        assert_equal "/oil-and-gas", primary_tag["content_with_tag"]["web_url"]
        assert_equal "Oil and Gas", primary_tag["title"]
        assert_equal "specialist-sector", response.headers["X-Slimmer-Format"]
      end

      it "sets expiry headers for 30 minutes" do
        get :subtopic, topic_slug: "oil-and-gas", subtopic_slug: "wells"

        assert_equal "max-age=1800, public",  response.headers["Cache-Control"]
      end
    end

    it "returns a 404 status for GET subtopic with an invalid subtopic tag" do
      content_store_does_not_have_item("/topic/oil-and-gas/coal")

      get :subtopic, topic_slug: "oil-and-gas", subtopic_slug: "coal"

      assert_equal 404, response.status
    end

    describe "invalid slugs" do
      it "returns a cacheable 404 without calling content-store if the subtopic slug is invalid" do
        get :subtopic, topic_slug: "oil-and-gas", subtopic_slug: "this & that"

        assert_equal "404", response.code
        assert_equal "max-age=600, public", response.headers["Cache-Control"]
        assert_not_requested(:get, %r{\A#{GdsApi::TestHelpers::ContentStore::CONTENT_STORE_ENDPOINT}})
      end
    end
  end
end
