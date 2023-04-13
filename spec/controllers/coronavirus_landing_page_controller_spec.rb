RSpec.describe CoronavirusLandingPageController do
  include CoronavirusContentItemHelper
  include GovukAbTesting::RspecHelpers

  describe "GET show" do
    before do
      stub_content_store_has_item(
        "/coronavirus",
        coronavirus_content_item,
        { max_age: 900, private: false },
      )
    end

    it "has a success response" do
      get :show

      expect(response).to have_http_status(:success)
    end

    context "User Experience Measurement practice AB test" do
      render_views
      it "should render the A version of the page" do
        @request.headers["HTTP_GOVUK_ABTEST_UXMPRACTICETEST"] = "A"
        get :show
        expect(response).to have_http_status(:success)
        expect(response.header["Vary"]).to eq("GOVUK-ABTest-UxmPracticeTest")
        expect(response.body).to include("<meta name=\"govuk:ab-test\"  content=\"UxmPracticeTest:A\"  data-analytics-dimension=\"68\"  data-allowed-variants=\"A,B,Z\">")
      end

      it "should render the B version of the page" do
        @request.headers["HTTP_GOVUK_ABTEST_UXMPRACTICETEST"] = "B"
        get :show
        expect(response).to have_http_status(:success)
        expect(response.header["Vary"]).to eq("GOVUK-ABTest-UxmPracticeTest")
        assert_equal("GOVUK-ABTest-UxmPracticeTest", response.headers["Vary"])
        expect(response.body).to include(
          "<meta name=\"govuk:ab-test\"  content=\"UxmPracticeTest:B\"  data-analytics-dimension=\"68\"  data-allowed-variants=\"A,B,Z\">",
        )
      end

      it "should render the Z version of the page" do
        @request.headers["HTTP_GOVUK_ABTEST_UXMPRACTICETEST"] = "Z"
        get :show
        expect(response).to have_http_status(:success)
        expect(response.header["Vary"]).to eq("GOVUK-ABTest-UxmPracticeTest")
        expect(response.body).to include("<meta name=\"govuk:ab-test\"  content=\"UxmPracticeTest:Z\"  data-analytics-dimension=\"68\"  data-allowed-variants=\"A,B,Z\">")
      end

      it "should render the page without an AB test variant" do
        get :show
        expect(response).to have_http_status(:success)

        expect(response.header["Vary"]).to eq("GOVUK-ABTest-UxmPracticeTest")
        expect(response.body).not_to include("<meta name=\"govuk:ab-test\">")
      end
    end
  end
end
