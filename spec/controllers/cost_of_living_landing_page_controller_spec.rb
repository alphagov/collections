RSpec.describe CostOfLivingLandingPageController do
  describe "GET show" do
    before do
      content ||= YAML.load_file(Rails.root.join("config/cost_of_living_landing_page/content_item.yml")).symbolize_keys

      stub_content_store_has_item(
        "/cost-of-living",
        content,
        { max_age: 900, private: false },
      )
    end

    it "has a success response" do
      allow(Rails.configuration).to receive(:unreleased_features).and_return(true)

      get :show
      expect(response).to have_http_status(:success)
    end

    context "feature flag is set to false" do
      it "returns a not found/404 status" do
        allow(Rails.configuration).to receive(:unreleased_features).and_return(false)

        expect(get(:show)).to have_http_status(:not_found)
      end
    end
  end
end
