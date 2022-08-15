RSpec.describe "CostOfLivingLandingPages", type: :request do
  before do
    stub_content_store_does_not_have_item("/cost-of-living")
  end

  describe "GET /show" do
    it "returns http success" do
      get "/cost-of-living"
      expect(response).to have_http_status(:success)
    end
  end
end
