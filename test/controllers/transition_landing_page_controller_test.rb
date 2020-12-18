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

    describe "BrexitChecker AB test" do
      context "In the en locale" do
        %w[A Z].each do |variant|
          it "Variant #{variant} shows the default button text" do
            with_variant BrexitChecker: variant do
              get :show
              assert_select ".govuk-button", text: "Start now"
            end
          end
        end

        it "Variant B shows the alternate button text" do
          with_variant BrexitChecker: "B" do
            get :show
            assert_select ".govuk-button", text: "Brexit checker: start now"
          end
        end
      end

      context "In the cy locale" do
        %w[A B Z].each do |variant|
          it "All variants shows the default button text" do
            setup_ab_variant("BrexitChecker", variant)
            get :show, params: { locale: "cy" }
            assert_select ".govuk-button", text: "Dechrau nawr"

            # we don't want to set Vary headers for pages that are not modified
            assert_response_not_modified_for_ab_test("BrexitChecker")
          end
        end
      end
    end
  end
end
