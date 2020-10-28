require "test_helper"

describe TransitionLandingPageController do
  include TaxonHelpers
  include GovukAbTesting::MinitestHelpers

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

      %w[LoggedIn LoggedOut].each do |variant|
        it "Variant #{variant} disables the search field" do
          with_variant AccountExperiment: variant do
            get :show
            assert_equal "true", response.headers["X-Slimmer-Remove-Search"]
          end
        end
      end

      it "Variant LoggedIn requests the signed-in header" do
        with_variant AccountExperiment: "LoggedIn" do
          get :show
          assert_equal "signed-in", response.headers["X-Slimmer-Show-Accounts"]
        end
      end

      it "Variant LoggedOut requests the signed-out header" do
        with_variant AccountExperiment: "LoggedOut" do
          get :show
          assert_equal "signed-out", response.headers["X-Slimmer-Show-Accounts"]
        end
      end
    end
  end
end
