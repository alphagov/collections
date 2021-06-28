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

      it "loads the production content item in production environments" do
        allow(ContentItem).to receive(:find!).and_return(coronavirus_content_item)

        expect(CoronavirusTimelineNationsContentItem).to_not receive(:load)
        expect(ContentItem).to receive(:find!)

        get :show, params: { timeline_nation: "foo" }
      end

      it "loads the fixture file in other environments" do
        allow(Rails.env).to receive(:development?).and_return(true)
        allow(CoronavirusTimelineNationsContentItem).to receive(:load).and_return(coronavirus_content_item_with_timeline_national_applicability)

        expect(CoronavirusTimelineNationsContentItem).to receive(:load)
        expect(ContentItem).to_not receive(:find!)

        get :show, params: { timeline_nation: "foo" }
      end

      it "shows no content text when there are no timeline entries for a nation" do
        stub_content_store_has_item("/coronavirus", coronavirus_content_item_with_timeline_national_applicability_without_wales)
        get :show, params: { timeline_nation: "wales" }

        expect(response.body).to have_content("There haven't been any recent updates for Wales.")
      end

      it "shows timeline for England" do
        stub_content_store_has_item("/coronavirus", coronavirus_content_item_with_timeline_national_applicability)
        get :show, params: { timeline_nation: "england" }

        expect(response.body).to have_selector("#nation-england:not(.covid-timeline__wrapper--hidden)")
        expect(response.body).to have_selector(".covid-timeline__wrapper--hidden", count: 3)
      end

      it "shows timeline for Northern Ireland" do
        stub_content_store_has_item("/coronavirus", coronavirus_content_item_with_timeline_national_applicability)
        get :show, params: { timeline_nation: "northern_ireland" }

        expect(response.body).to have_selector("#nation-northern_ireland:not(.covid-timeline__wrapper--hidden)")
        expect(response.body).to have_selector(".covid-timeline__wrapper--hidden", count: 3)
      end

      it "shows timeline for Scotland" do
        stub_content_store_has_item("/coronavirus", coronavirus_content_item_with_timeline_national_applicability)
        get :show, params: { timeline_nation: "scotland" }

        expect(response.body).to have_selector("#nation-scotland:not(.covid-timeline__wrapper--hidden)")
        expect(response.body).to have_selector(".covid-timeline__wrapper--hidden", count: 3)
      end

      it "shows timeline for Wales" do
        stub_content_store_has_item("/coronavirus", coronavirus_content_item_with_timeline_national_applicability)
        get :show, params: { timeline_nation: "wales" }

        expect(response.body).to have_selector("#nation-wales:not(.covid-timeline__wrapper--hidden)")
        expect(response.body).to have_selector(".covid-timeline__wrapper--hidden", count: 3)
      end
    end
  end
end
