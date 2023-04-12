RSpec.describe EmbassiesController do
  describe "GET index" do
    before do
      stub_content_store_has_item("/world/embassies", fetch_fixture("embassies_index"))
    end

    it "has a success response" do
      get :index
      expect(response).to have_http_status(:success)
    end
  end
end
