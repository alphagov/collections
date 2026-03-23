RSpec.describe WorldController do
  let(:world) { GovukSchemas::Example.find("world_index", example_name: "world_index") }
  let(:base_path) { world["base_path"] }

  describe "GET index" do
    context "the request is successful" do
      before do
        stub_conditional_loader_returns_content_item_for_path(base_path, world)
      end

      it "successfully renders the page" do
        get :index

        expect(response).to have_http_status(:success)
        expect(response).to render_template(:index)
      end
    end

    context "the request is not successful" do
      before do
        stub_conditional_loader_does_not_return_content_item_for_path(base_path)
      end

      it "responds with a 404" do
        get :index, params: { name: "blah" }

        expect(response).to have_http_status(:not_found)
      end
    end
  end
end
