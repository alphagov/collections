RSpec.describe RolesController do
  include SearchApiHelpers

  def prime_minister
    GovukSchemas::Example.find("role", example_name: "prime_minister")
  end

  let(:base_path) { prime_minister["base_path"] }
  let(:role) { base_path.split("/").last }

  describe "GET show" do
    before do
      stub_content_store_has_item(base_path, prime_minister)
      stub_content_store_does_not_have_item("/government/ministers/she-ra")
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
