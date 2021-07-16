RSpec.describe CoronavirusLandingPageController do
  include CoronavirusContentItemHelper

  describe "GET show" do
    before do
      stub_content_store_has_item("/coronavirus", coronavirus_content_item)
      stub_coronavirus_statistics
    end

    it "has a success response" do
      get :show
      expect(response).to have_http_status(:success)
    end

    it "sets a 5 minute cache header" do
      get :show
      expect(response.headers["Cache-Control"]).to eq("max-age=#{5.minutes}, public")
    end

    context "when coronavirus statistics are not available" do
      before { stub_request(:get, /coronavirus.data.gov.uk/).to_return(status: 500) }

      it "reduces the cache time to 30 seconds" do
        get :show
        expect(response.headers["Cache-Control"]).to eq("max-age=#{30.seconds}, public")
      end
    end

    context "when testing national_applicability" do
      render_views

      it "shows timeline for England" do
        get :show, params: { nation: "england" }

        expect(response.body).to have_selector("#nation-england:not(.covid-timeline__wrapper--hidden)")
        expect(response.body).to have_selector(".covid-timeline__wrapper--hidden", count: 3)
      end

      it "shows timeline for Northern Ireland" do
        get :show, params: { nation: "northern_ireland" }

        expect(response.body).to have_selector("#nation-northern_ireland:not(.covid-timeline__wrapper--hidden)")
        expect(response.body).to have_selector(".covid-timeline__wrapper--hidden", count: 3)
      end

      it "shows timeline for Scotland" do
        get :show, params: { nation: "scotland" }

        expect(response.body).to have_selector("#nation-scotland:not(.covid-timeline__wrapper--hidden)")
        expect(response.body).to have_selector(".covid-timeline__wrapper--hidden", count: 3)
      end

      it "shows timeline for Wales" do
        get :show, params: { nation: "wales" }

        expect(response.body).to have_selector("#nation-wales:not(.covid-timeline__wrapper--hidden)")
        expect(response.body).to have_selector(".covid-timeline__wrapper--hidden", count: 3)
      end

      it "shows no content text when there are no timeline entries for a nation" do
        stub_content_store_has_item("/coronavirus", coronavirus_content_item_with_timeline_national_applicability_without_wales)
        get :show, params: { nation: "wales" }

        expect(response.body).to have_content(I18n.t("coronavirus_landing_page.show.timeline.no_updates.body", nation: "Wales"))
        expect(response.body).to match(I18n.t("coronavirus_landing_page.show.timeline.no_updates.wales.additional_country_guidance_html"))
      end
    end
  end
end
