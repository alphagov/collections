require "test_helper"

describe TaxonsController do
  include RummagerHelpers

  describe "GET show" do
    before do
      content_store_has_item("/education",
                             content_id: "education-content-id",
                             base_path: "/education",
                             title: "Education")
      stub_content_for_taxon("education-content-id", [])
    end
  end
end
