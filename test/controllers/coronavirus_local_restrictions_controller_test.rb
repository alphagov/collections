require "test_helper"
require "gds_api/test_helpers/mapit"

describe CoronavirusLocalRestrictionsController do
  include GdsApi::TestHelpers::Mapit
  include GdsApi::TestHelpers::ContentStore

  before do
    stub_content_store_has_item("/find-coronavirus-local-restrictions", {})
  end

  describe "GET show" do
    it "correctly renders the local restrictions page" do
      get :show

      assert_response :success
      assert_template :show
    end
  end

  describe "POST results" do
    it "renders the results page when given a real postcode" do
      restriction = LocalRestriction.new("E01000123",
                                         { "name" => "Coruscant Planetary Council" })
      LocalRestriction.stubs(:find).returns(restriction)

      postcode = "E1 8QS"
      areas = [
        {
          "gss" => restriction.gss_code,
          "name" => restriction.area_name,
          "type" => "LBO",
        },
      ]
      stub_mapit_has_a_postcode_and_areas(postcode, [], areas)

      post :results, params: { "postcode-lookup" => postcode }

      assert_response :success
      assert_template :results
    end

    it "renders the local restriction page when given an incorrect postcode" do
      postcode = "invalid postcode"
      stub_mapit_does_not_have_a_postcode(postcode)
      post :results, params: { "postcode-lookup" => postcode }

      assert_response :success
      assert_template :show
    end

    it "renders the local restriction page when the postcode is blank" do
      postcode = ""
      post :results, params: { "postcode-lookup" => postcode }

      assert_response :success
      assert_template :show
    end

    it "renders the local restriction page when the postcode param is not passed in" do
      post :results

      assert_response :success
      assert_template :show
    end
  end
end
