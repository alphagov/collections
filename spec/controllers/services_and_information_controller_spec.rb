RSpec.describe ServicesAndInformationController do
  include SearchApiHelpers
  include ServicesAndInformationHelpers

  describe "with a valid organisation slug" do
    it "sets expiry headers for 30 minutes" do
      stub_services_and_information_content_item
      stub_services_and_information_links("hm-revenue-customs")

      get :index, params: { organisation_id: "hm-revenue-customs" }

      expect(response.headers["Cache-Control"]).to eq("max-age=1800, public")
    end
  end

  describe "GET services and information page" do
    it "returns a 404 status for GET services and information with an invalid organisation id" do
      stub_content_store_does_not_have_item("/government/organisations/hm-revenue-customs/services-information")

      get :index, params: { organisation_id: "hm-revenue-customs" }

      expect(response).to have_http_status(:not_found)
    end

    it "renders the page correctly when there are unexpanded links in the search_api results" do
      stub_services_and_information_content_item
      stub_services_and_information_links_with_missing_keys("hm-revenue-customs")

      get :index, params: { organisation_id: "hm-revenue-customs" }

      expect(response).to have_http_status(:success)
    end
  end
end
