RSpec.describe CostOfLivingLandingPageController do
  describe "GET show" do
    before do
      content_item ||= YAML.load_file(Rails.root.join("config/cost_of_living_landing_page/content_item.yml")).symbolize_keys

      stub_content_store_has_item(
        "/cost-of-living",
        content_item,
        { max_age: 900, private: false },
      )
    end

    it "has a success response" do
      get :show
      expect(response).to have_http_status(:success)
    end
  end
end
