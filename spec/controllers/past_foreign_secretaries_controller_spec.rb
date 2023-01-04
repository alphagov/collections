RSpec.describe PastForeignSecretariesController do
  describe "GET index" do
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

    it "has a success response" do
      get :index
      expect(response).to have_http_status(:success)
    end
  end
end
