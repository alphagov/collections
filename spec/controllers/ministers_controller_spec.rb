RSpec.describe MinistersController do
  let(:ministers) { GovukSchemas::Example.find("ministers_index", example_name: "ministers_index-reshuffle-mode-off") }
  let(:base_path) { ministers["base_path"] }

  describe "index" do
    before do
      stub_conditional_loader_returns_content_item_for_path(base_path, ministers)
    end

    it "responds with a 200" do
      get :index

      expect(response).to have_http_status(:success)
      expect(response).to render_template(:index)
    end
  end
end
