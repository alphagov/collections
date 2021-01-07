require "test_helper"
require "gds_api/test_helpers/mapit"

describe CoronavirusLocalRestrictionsController do
  include GdsApi::TestHelpers::Mapit
  include GdsApi::TestHelpers::ContentStore

  before do
    stub_content_store_has_item("/find-coronavirus-local-restrictions", {})
    CoronavirusLocalRestrictionsController.any_instance.stubs(:out_of_date?).returns(false)
  end

  describe "GET show" do
    it "returns a cached redirect when Rails is in production" do
      Rails.env.stubs(:production?).returns(true)
      get :show

      assert_equal "max-age=#{30.minutes}, public", response.headers["Cache-Control"]
      assert_response :temporary_redirect
      assert_redirected_to "/guidance/national-lockdown-stay-at-home"
    end

    it "renders the show template when not given a postcode" do
      get :show

      assert_response :success
      assert_template :show
    end

    it "caches responses publicly for 30 minutes by default" do
      get :show

      assert_equal "max-age=#{30.minutes}, public", response.headers["Cache-Control"]
    end

    it "caches responses for for 5 minutes when the data is being updated" do
      CoronavirusLocalRestrictionsController.any_instance.stubs(:out_of_date?).returns(true)

      get :show

      assert_equal "max-age=#{5.minutes}, public", response.headers["Cache-Control"]
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

    it "reduces the cache time when an area has an upcoming future restriction" do
      restriction = LocalRestriction.new(
        "E01000123",
        {
          "name" => "Coruscant Planetary Council",
          "restrictions" => [
            {
              "alert_level" => 3,
              "start_date" => Date.new(2020, 12, 15),
              "start_time" => "10:00",
            },
          ],
        },
      )
      LocalRestriction.stubs(:find).returns(restriction)

      postcode = "E1 8QS"
      stub_mapit_has_a_postcode_and_areas(postcode, [], [{
        "gss" => restriction.gss_code,
        "name" => restriction.area_name,
        "type" => "LBO",
        "country_name" => "England",
      }])

      travel_to(Time.zone.parse("2020-12-15 9:50")) do
        get :show, params: { postcode: postcode }

        assert_equal "max-age=#{10.minutes}, public", response.headers["Cache-Control"]
      end
    end
  end
end
