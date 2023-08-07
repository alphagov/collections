RSpec.describe WorldController do
  describe "GET index" do
    before do
      stub_content_store_has_item("/world", GovukSchemas::Example.find("world_index", example_name: "world_index"))
    end

    it "has a success response" do
      get :index
      expect(response).to have_http_status(:success)
    end
  end
end
