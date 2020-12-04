require "test_helper"

describe DitLandingPageController do
  describe "GET show" do
    it "renders the page for the en locale" do
      get :show
      assert_response :success
      assert_select "h1", "Trade with the UK from 1 January 2021 as a business based in the EU"
    end
  end
end
