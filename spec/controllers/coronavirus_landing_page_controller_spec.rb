RSpec.describe CoronavirusLandingPageController do
  include CoronavirusContentItemHelper

  describe "GET show" do
    before do
      stub_content_store_has_item(
        "/coronavirus",
        coronavirus_content_item,
        { max_age: 900, private: false },
      )
    end

    it "has a success response" do
      get :show
      expect(response).to have_http_status(:success)
    end
  end
end
