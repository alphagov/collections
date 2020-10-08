require "test_helper"

describe CoronavirusLocalRestrictionsController do
  describe "GET show" do
    it "correctly renders the local restrictions page" do
      get :show

      assert_response :success
      assert_template :show
    end
  end
end
