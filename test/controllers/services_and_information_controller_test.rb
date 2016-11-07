require_relative '../test_helper'

describe ServicesAndInformationController do
  include RummagerHelpers
  include ServicesAndInformationHelpers

  before do
    stub_services_and_information_links("hm-revenue-customs")
  end

  describe "with a valid organisation slug" do
    it "sets expiry headers for 30 minutes" do
      stub_services_and_information_content_item
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
  end
end
