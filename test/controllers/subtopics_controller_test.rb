require "test_helper"

describe SubtopicsController do
  describe "GET subtopic" do
    describe "with a valid topic and subtopic slug" do
      setup do
        stub_services_for_subtopic("content-id-for-wells", "oil-and-gas", "wells")
      end

      it "sets expiry headers for 30 minutes" do
        get :show, params: { topic_slug: "oil-and-gas", subtopic_slug: "wells" }

        assert_equal "max-age=1800, public", response.headers["Cache-Control"]
      end
    end

    it "returns a 404 status for GET subtopic with an invalid subtopic tag" do
      stub_content_store_does_not_have_item("/topic/oil-and-gas/coal")

      get :show, params: { topic_slug: "oil-and-gas", subtopic_slug: "coal" }

      assert_equal 404, response.status
    end
  end

  def stub_services_for_subtopic(content_id, parent_path, path)
    stub_content_store_has_item(
      "/topic/#{parent_path}/#{path}",
      content_item_for_base_path("/topic/#{parent_path}/#{path}").merge(
        "content_id" => content_id,
        "links" => {
          "parent" => [{
            "title" => "Parent Topic Title",
            "base_path" => "/#{parent_path}",
          }],
        },
      ),
    )

    ListSet.stubs(:new).returns(
      [ListSet::List.new("test", [])],
    )

    Services.search_api.stubs(:search).with(
      count: "0",
      filter_topic_content_ids: [content_id],
      facet_organisations: "1000",
    ).returns(
      stub_search_has_specialist_sector_organisations("#{parent_path}/#{path}"),
    )
  end
end
