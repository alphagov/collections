RSpec.describe SubtopicsController do
  include SearchApiHelpers

  describe "GET subtopic" do
    describe "with a valid topic and subtopic slug" do
      before do
        stub_services_for_subtopic("content-id-for-wells", "oil-and-gas", "wells")
      end

      it "sets expiry headers for 30 minutes" do
        get :show, params: { topic_slug: "oil-and-gas", subtopic_slug: "wells" }

        expect(response.headers["Cache-Control"]).to eq("max-age=300, public")
      end
    end

    it "returns a 404 status for GET subtopic with an invalid subtopic tag" do
      stub_content_store_does_not_have_item("/topic/oil-and-gas/coal")

      get :show, params: { topic_slug: "oil-and-gas", subtopic_slug: "coal" }

      expect(response).to have_http_status(:not_found)
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

    allow(ListSet)
    .to receive(:new)
    .and_return([ListSet::List.new("test", [])])

    params = {
      count: "0",
      filter_topic_content_ids: [content_id],
      facet_organisations: "1000",
    }

    body = stub_search_has_specialist_sector_organisations("#{parent_path}/#{path}")

    stub_search(params:, body:)
  end
end
