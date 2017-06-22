require "test_helper"

describe TaxonsController do
  include RummagerHelpers
  include GovukAbTesting::MinitestHelpers

  describe "GET show" do
    before do
      content_store_has_item("/education",
                             content_id: "education-content-id",
                             base_path: "/education",
                             title: "Education")
      stub_content_for_taxon("education-content-id", [])
    end

    it "returns 200 if the new navigation is enabled in variant 'B'" do
      with_B_variant do
        get :show, params: { taxon_base_path: "education" }
      end

      assert_response 200
    end

    it "returns 200 if the new navigation is enabled in variant 'A'" do
      with_A_variant do
        get :show, params: { taxon_base_path: "education" }
      end

      assert_response 200
    end
  end
end
