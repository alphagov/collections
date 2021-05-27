RSpec.describe TransitionLandingPageController do
  include TaxonHelpers

  describe "GET show" do
    before do
      brexit_taxon = taxon
      brexit_taxon["base_path"] = "/brexit"
      stub_content_store_has_item(brexit_taxon["base_path"], brexit_taxon)
      stub_content_store_has_item(brexit_taxon["base_path"] + ".cy", brexit_taxon)
    end

    %w[cy en].each do |locale|
      params = locale == "en" ? {} : { locale: locale }

      it "renders the page for the #{locale} locale" do
        get :show, params: params
        expect(response).to have_http_status(:success)
      end
    end

    it "disables the search field" do
      get :show
      expect(response.headers["X-Slimmer-Remove-Search"]).to eq("true")
    end

    it "sets the Vary: GOVUK-Account-Session response header" do
      get :show
      expect(response.headers["Vary"]).to include("GOVUK-Account-Session")
    end

    it "requests the signed-out header" do
      get :show
      expect(response.headers["X-Slimmer-Show-Accounts"]).to eq("signed-out")
    end

    context "the GOVUK-Account-Session header is set" do
      it "requests the signed-in header" do
        request.headers["GOVUK-Account-Session"] = "foo"
        get :show
        expect(response.headers["X-Slimmer-Show-Accounts"]).to eq("signed-in")
      end
    end
  end
end
