require "test_helper"
require "gds_api/test_helpers/mapit"

describe CoronavirusLocalRestrictionsController do
  include GdsApi::TestHelpers::Mapit
  include GdsApi::TestHelpers::ContentStore

  before do
    stub_content_store_has_item("/find-coronavirus-local-restrictions", {})
  end

  describe "GET show" do
    it "renders the show template when not given a postcode" do
      get :show

      assert_response :success
      assert_template :show
    end

    it "renders the show template when given an invalid postcode" do
      get :show, params: { postcode: "not-a-postcode" }

      assert_response :success
      assert_template :show
    end

    it "renders the no_information template when given a postcode without information" do
      stub_mapit_has_a_postcode_and_areas("E1 8QS", [], [])
      get :show, params: { postcode: "E1 8QS" }

      assert_response :success
      assert_template :no_information
    end

    it "renders the results template for an area with information" do
      restriction = LocalRestriction.new("E01000123",
                                         { "name" => "Coruscant Planetary Council" })
      LocalRestriction.stubs(:find).returns(restriction)

      postcode = "E1 8QS"
      stub_mapit_has_a_postcode_and_areas(postcode, [], [{
        "gss" => restriction.gss_code,
        "name" => restriction.area_name,
        "type" => "LBO",
        "country_name" => "England",
      }])
      get :show, params: { postcode: postcode }

      assert_response :success
      assert_template :results
    end
  end

  describe "POST legacy" do
    it "redirects to the GET endpoint" do
      post :legacy, params: { "postcode-lookup" => "E1 8QS" }

      assert_redirected_to find_coronavirus_local_restrictions_path(postcode: "E1 8QS")
    end
  end
end
