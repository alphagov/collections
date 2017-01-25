require "test_helper"

describe TopicsController do
  include ContentSchemaHelpers
  include RummagerHelpers

  describe "GET topic" do
    describe "with a valid topic slug" do
      before do
        content_store_has_item('/topic/oil-and-gas', content_schema_example(:topic, :topic))
      end

      it "sets expiry headers for 30 minutes" do
        get :show, topic_slug: "oil-and-gas"

        assert_equal "max-age=1800, public", response.headers["Cache-Control"]
      end
    end

    it "returns a 404 status for GET topic with an invalid sector tag" do
      content_store_does_not_have_item("/topic/oil-and-gas")
      get :show, topic_slug: "oil-and-gas"

      assert_equal 404, response.status
    end
  end

  describe "GET subtopic" do
    describe "with a valid topic and subtopic slug" do
      setup do
        content_store_has_item(
          "/topic/oil-and-gas/wells",
          content_item_for_base_path("/topic/oil-and-gas/wells").merge(
            "content_id" => 'content-id-for-wells',
            "links" => {
              "parent" => [{
                "title" => "Oil and Gas",
                "base_path" => "/oil-and-gas",
              }],
            }),
        )

        ListSet.stubs(:new).returns(
          [ListSet::List.new("test", [])]
        )

        Services.rummager.stubs(:search).with(
          count: "0",
          filter_topic_content_ids: ["content-id-for-wells"],
          facet_organisations: "1000",
        ).returns(
          rummager_has_specialist_sector_organisations(
            "oil-and-gas/wells",
          )
         )
      end

      it "sets expiry headers for 30 minutes" do
        get :subtopic, topic_slug: "oil-and-gas", subtopic_slug: "wells"

        assert_equal "max-age=1800, public", response.headers["Cache-Control"]
      end
    end

    it "returns a 404 status for GET subtopic with an invalid subtopic tag" do
      content_store_does_not_have_item("/topic/oil-and-gas/coal")

      get :subtopic, topic_slug: "oil-and-gas", subtopic_slug: "coal"

      assert_equal 404, response.status
    end
  end
end
