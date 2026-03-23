RSpec.describe RolesController do
  include SearchApiHelpers

  let(:prime_minister) { GovukSchemas::Example.find("role", example_name: "prime_minister") }
  let(:base_path) { prime_minister["base_path"] }
  let(:role) { base_path.split("/").last }

  describe "GET show" do
    before do
      stub_conditional_loader_returns_content_item_for_path(base_path, prime_minister)
      stub_conditional_loader_does_not_return_content_item_for_path("/government/ministers/she-ra")
      stub_minister_announcements(role)
    end

    it "when the content item exists" do
      get :show, params: { name: role }
      expect(response).to have_http_status(:success)
      expect(response).to render_template(:show)
    end

    it "when there is no content item" do
      get :show, params: { name: "she-ra" }
      expect(response).to have_http_status(:not_found)
    end
  end
end
