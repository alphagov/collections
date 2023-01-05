RSpec.describe PastForeignSecretariesController do
  before do
    stub_content_store_has_item(
      "/government/history/past-foreign-secretaries",
      title: "Past Foreign Secretaries",
      base_path: "/government/history/past-foreign-secretaries",
      links: {
        parent: [
          "title": "History of the UK government",
          "locale": "en",
          "api_path": "/api/content/government/history",
          "base_path": "/government/history",
        ],
      },
    )
  end

  describe "GET index" do
    it "has a success response" do
      get :index
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET show for an individual past foreign secretary" do
    it "has a success response for a past foreign secretary with an individual page" do
      get :show, params: { id: "austen-chamberlain" }
      expect(response).to have_http_status(:success)
    end

    it "responds with a 404 if the requested foreign secretary does not exist" do
      get :show, params: { id: "mr-blobby" }
      expect(response).to have_http_status(:not_found)
    end
  end
end
