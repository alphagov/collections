require "test_helper"

describe DitLandingPageController do
  describe "GET show" do
    %w[cy en].each do |locale|
      params = locale == "en" ? {} : { locale: locale }

      it "renders the page for the #{locale} locale" do
        get :show, params: params

        assert_response :success
      end
    end
  end
end
