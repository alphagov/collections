require_relative '../test_helper'
require "climate_control"

describe ServicesAndInformationController do
  include RummagerHelpers
  include ServicesAndInformationHelpers
  include GovukAbTesting::MinitestHelpers

  describe "with a valid organisation slug" do
    it "sets expiry headers for 30 minutes" do
      stub_services_and_information_content_item
      stub_services_and_information_links("hm-revenue-customs")

      get :index, organisation_id: "hm-revenue-customs"

      assert_equal "max-age=1800, public", response.headers["Cache-Control"]
    end
  end

  describe "GET services and information page" do
    it "returns a 404 status for GET services and information with an invalid organisation id" do
      content_store_does_not_have_item("/government/organisations/hm-revenue-customs/services-information")

      get :index, organisation_id: "hm-revenue-customs"

      assert_equal 404, response.status
    end

    it "renders the page correctly when there are unexpanded links in the rummager results" do
      stub_services_and_information_content_item
      stub_services_and_information_links_with_missing_keys("hm-revenue-customs")

      get :index, organisation_id: "hm-revenue-customs"

      assert_equal 200, response.status
    end

    describe "A/B test" do
      before do
        stub_education_services_and_information_content_item
        stub_services_and_information_links("department-for-education")
      end

      describe "new navigation is not enabled" do
        ["A", "B"].each do |variant|
          it "returns the original version of the page for variant #{variant}" do
            setup_ab_variant("EducationNavigation", variant)

            get :index, organisation_id: "department-for-education"

            assert_response 200
            assert_response_not_modified_for_ab_test
          end
        end
      end

      describe "new navigation is enabled" do
        ["A", "B"].each do |variant|
          it "does not redirect non-education organisations in the #{variant} variant" do
            stub_services_and_information_content_item
            stub_services_and_information_links("hm-revenue-customs")

            setup_ab_variant("EducationNavigation", variant)

            with_new_navigation_enabled do
              get :index, organisation_id: "hm-revenue-customs"
            end

            assert_response 200
            assert_response_not_modified_for_ab_test
          end
        end

        it "shows the original page in the A variant" do
          with_new_navigation_enabled do
            with_variant EducationNavigation: "A" do
              get :index, organisation_id: "department-for-education"

              assert_response 200
            end
          end
        end

        it "redirects B variant of education" do
          with_new_navigation_enabled do
            with_variant EducationNavigation: "B", assert_meta_tag: false do
              get :index, organisation_id: "department-for-education"

              assert_response 302
              assert_redirected_to controller: "taxons", action: "show", taxon_base_path: "education"
            end
          end
        end
      end
    end
  end
end
