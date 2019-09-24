require "test_helper"

describe EmailSignupsController do
  setup do
    @valid_subtopic_params = { topic_slug: "oil-and-gas", subtopic_slug: "wells" }
    content_store_has_item(
      "/topic/oil-and-gas/wells",
      content_item_for_base_path("/topic/oil-and-gas/wells").merge("links" => {
          "parent" => [{
            "title" => "Oil and Gas",
            "base_path" => "/oil-and-gas",
          }],
        }),
    )

    @invalid_subtopic_params = { topic_slug: "invalid", subtopic_slug: "subtopic" }
    content_store_does_not_have_item("/topic/invalid/subtopic")

    @email_signup = EmailSignup.new(nil)
    @email_signup.stubs(:save)
    @email_signup.stubs(:valid?).returns(true)

    EmailSignup.stubs(:new).returns(@email_signup)
  end

  describe "GET :new with a valid subtopic" do
    it "displays the subscription form" do
      get :new, params: @valid_subtopic_params

      assert_response :success
    end
  end

  describe "GET :new with an invalid subtopic" do
    it "shows an error message" do
      get :new, params: @invalid_subtopic_params

      assert_response :not_found
    end
  end

  describe "POST :create with a valid email signup" do
    setup do
      @email_signup.stubs(:save).returns(true)
      @email_signup.expects(:subscription_url).returns("http://email_alert_api_signup_url")
    end

    it "registers the signup" do
      @email_signup.expects(:save).returns(true)

      post :create, params: @valid_subtopic_params
    end

    it "redirects to the email-alert-api URL" do
      post :create, params: @valid_subtopic_params

      assert_response :redirect
      assert_redirected_to "http://email_alert_api_signup_url"
    end
  end

  describe "POST :create with an invalid email signup" do
    it "doesn't register the subscription" do
      @email_signup.expects(:save).never

      post :create, params: @invalid_subtopic_params
    end

    it "404s" do
      post :create, params: @invalid_subtopic_params

      assert_response :not_found
    end
  end
end
