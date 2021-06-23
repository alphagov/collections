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

      before do
        allow(Rails.env).to receive(:production?).and_return(true)
      end

      it "loads the production content item in production environments" do
        expect(CoronavirusTimelineNationsContentItem).to_not receive(:load)

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

        expect(response.body).to have_content("In England")
      end

      it "shows timeline for Northern Ireland" do
        stub_content_store_has_item("/coronavirus", coronavirus_content_item_with_timeline_national_applicability)
        get :show, params: { timeline_nation: "northern_ireland" }

        expect(response.body).to have_content("In Northern Ireland")
      end

      it "shows timeline for Scotland" do
        stub_content_store_has_item("/coronavirus", coronavirus_content_item_with_timeline_national_applicability)
        get :show, params: { timeline_nation: "scotland" }

        expect(response.body).to have_content("In Scotland")
      end

      it "shows timeline for Wales" do
        stub_content_store_has_item("/coronavirus", coronavirus_content_item_with_timeline_national_applicability)
        get :show, params: { timeline_nation: "wales" }

        expect(response.body).to have_content("In Wales")
      end
    end
  end
end
