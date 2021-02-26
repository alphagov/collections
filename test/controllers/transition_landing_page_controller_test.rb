require "test_helper"

describe TransitionLandingPageController do
  include TaxonHelpers

  describe "GET show" do
    before do
      brexit_taxon = taxon
      brexit_taxon["base_path"] = "/transition"
      stub_content_store_has_item(brexit_taxon["base_path"], brexit_taxon)
      stub_content_store_has_item(brexit_taxon["base_path"] + ".cy", brexit_taxon)
    end

    %w[cy en].each do |locale|
      params = locale == "en" ? {} : { locale: locale }

      it "renders the page for the #{locale} locale" do
        get :show, params: params
        assert_response :success
      end
    end

    describe "accounts are enabled" do
      before do
        Rails.configuration.stubs(:feature_flag_govuk_accounts).returns(true)
      end

      it "disables the search field" do
        get :show
        assert_equal "true", response.headers["X-Slimmer-Remove-Search"]
      end

      it "sets the Vary: GOVUK-Account-Session response header" do
        get :show
        assert response.headers["Vary"].include? "GOVUK-Account-Session"
      end

      it "requests the signed-out header" do
        get :show
        assert_equal "signed-out", response.headers["X-Slimmer-Show-Accounts"]
      end

      context "the GOVUK-Account-Session header is set" do
        it "requests the signed-in header" do
          request.headers["GOVUK-Account-Session"] = "foo"
          get :show
          assert_equal "signed-in", response.headers["X-Slimmer-Show-Accounts"]
        end
      end
    end
  end
end
