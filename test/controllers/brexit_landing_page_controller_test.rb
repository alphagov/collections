require "test_helper"

describe BrexitLandingPageController do
  include TaxonHelpers
  include GovukAbTesting::MinitestHelpers

  describe "GET show" do
    before do
      brexit_taxon = taxon
      brexit_taxon["base_path"] = "/brexit"
      content_store_has_item(brexit_taxon["base_path"], brexit_taxon)
    end

    it "renders the page" do
      get :show

      assert_response :success
    end

    context "Brexit landing page AB tests" do
      it "renders A variant" do
        with_variant BrexitLandingPageTest: "A" do
          get :show

          assert_response :success
          assert_equal("GOVUK-ABTest-BrexitLandingPageTest", response.headers["Vary"])
          assert_includes(
            response.body,
            "<meta name=\"govuk:ab-test\" content=\"BrexitLandingPageTest:A\" data-analytics-dimension=\"68\" data-allowed-variants=\"A,B\">",
          )
        end
      end

      it "renders B variant" do
        with_variant BrexitLandingPageTest: "B" do
          get :show

          assert_response :success
          assert_equal("GOVUK-ABTest-BrexitLandingPageTest", response.headers["Vary"])
          assert_includes(
            response.body,
            "<meta name=\"govuk:ab-test\" content=\"BrexitLandingPageTest:B\" data-analytics-dimension=\"68\" data-allowed-variants=\"A,B\">",
          )
        end
      end
    end
  end
end
