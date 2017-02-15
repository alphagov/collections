require "test_helper"
require "climate_control"

describe TaxonsController do

  include RummagerHelpers
  include GovukAbTesting::MinitestHelpers

  describe "GET show" do

    before do
      content_store_has_item("/education", content_id: "education-content-id")
      stub_content_for_taxon("education-content-id", [])
    end

    it "returns 200 if the new navigation is enabled" do
      with_new_navigation_enabled do
        get :show, taxon_base_path: "education"
      end

      assert_response 200
    end

    it "returns 404 if the new navigation is disabled" do
      get :show, taxon_base_path: "education"

      assert_response 404
    end

    %w(A B).each do |variant|
      it "returns the taxon page in the #{variant} variant" do
        with_new_navigation_enabled do
          with_variant EducationNavigation: variant do
            get :show, taxon_base_path: "education"

            assert_response 200
          end
        end
      end
    end
  end
end
