require "test_helper"

describe TransitionLandingPageController do
  include TaxonHelpers

  describe "GET show" do
    before do
      brexit_taxon = taxon
      brexit_taxon["base_path"] = "/brexit"
      stub_content_store_has_item(brexit_taxon["base_path"], brexit_taxon)
    end

    it "renders the page" do
      get :show

      assert_response :success
    end
  end
end
