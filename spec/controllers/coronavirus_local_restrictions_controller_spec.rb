require "gds_api/test_helpers/mapit"

RSpec.describe CoronavirusLocalRestrictionsController do
  include GdsApi::TestHelpers::Mapit
  render_views

  before do
    stub_content_store_has_item("/find-coronavirus-local-restrictions", {})
    allow_any_instance_of(CoronavirusLocalRestrictionsController)
    .to receive(:out_of_date?)
    .and_return(false)
  end

  describe "GET show" do
    it "returns a cached redirect when Rails is in production" do
      allow(Rails.env)
      .to receive(:production?)
      .and_return(true)

      get :show

      expect(response.headers["Cache-Control"]).to eq("max-age=#{30.minutes}, public")
      expect(response).to have_http_status(:redirect)
      expect(response).to redirect_to("/guidance/national-lockdown-stay-at-home")
    end

    it "renders the show template when not given a postcode" do
      get :show

      expect(response).to have_http_status(:success)
      assert_template :show
    end

    it "caches responses publicly for 30 minutes by default" do
      get :show

      expect(response.headers["Cache-Control"]).to eq("max-age=#{30.minutes}, public")
    end

    it "caches responses for for 5 minutes when the data is being updated" do
      allow_any_instance_of(CoronavirusLocalRestrictionsController)
      .to receive(:out_of_date?)
      .and_return(true)

      get :show

      expect(response.headers["Cache-Control"]).to eq("max-age=#{5.minutes}, public")
    end

    it "renders the show template when given an invalid postcode" do
      get :show, params: { postcode: "not-a-postcode" }

      expect(response).to have_http_status(:success)
      assert_template :show
    end

    it "renders the no_information template when given a postcode without information" do
      stub_mapit_has_a_postcode_and_areas("E1 8QS", [], [])
      get :show, params: { postcode: "E1 8QS" }

      expect(response).to have_http_status(:success)
      expect(response).to render_template(:no_information)
    end

    it "renders the no_information template when there is no restriction data for an area in local_restrictions.yml" do
      postcode = "E1 8QS"
      gss = SecureRandom.alphanumeric(10)

      areas = [
        {
          "gss" => gss,
          "name" => "Tatooine",
          "type" => "LBO",
          "country_name" => "England",
        },
      ]

      allow(LocalRestriction)
      .to receive(:find)
      .with(gss)
      .and_return(nil)

      stub_mapit_has_a_postcode_and_areas(postcode, [], areas)

      get :show, params: { postcode: "E1 8QS" }

      expect(response).to have_http_status(:success)
      expect(response).to render_template(:no_information)
    end

    it "renders the results template for an area with information" do
      restriction = LocalRestriction.new("E01000123",
                                         { "name" => "Coruscant Planetary Council" })
      allow(LocalRestriction)
      .to receive(:find)
      .and_return(restriction)
      postcode = "E1 8QS"
      stub_mapit_has_a_postcode_and_areas(postcode, [], [{
        "gss" => restriction.gss_code,
        "name" => restriction.area_name,
        "type" => "LBO",
        "country_name" => "England",
      }])
      get :show, params: { postcode: postcode }

      expect(response).to have_http_status(:success)
      expect(response).to render_template(:results)
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

      allow(LocalRestriction)
      .to receive(:find)
      .and_return(restriction)

      postcode = "E1 8QS"
      stub_mapit_has_a_postcode_and_areas(postcode, [], [{
        "gss" => restriction.gss_code,
        "name" => restriction.area_name,
        "type" => "LBO",
        "country_name" => "England",
      }])

      travel_to(Time.zone.parse("2020-12-15 9:50")) do
        get :show, params: { postcode: postcode }

        expect(response.headers["Cache-Control"]).to eq("max-age=#{10.minutes}, public")
      end
    end
  end
end
