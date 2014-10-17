require "test_helper"

describe EmailSignupsController do
  setup do
    @subtopic_slug = "oil-and-gas/wells"
    collections_api_has_curated_lists_for("/#{@subtopic_slug}")
    collections_api_has_no_curated_lists_for("/invalid/subtopic")

    @email_signup = EmailSignup.new(nil)
    @email_signup.stubs(:save)
    @email_signup.stubs(:valid?).returns(true)

    EmailSignup.stubs(:new).returns(@email_signup)
  end

  describe 'GET :new with a valid subtopic' do
    it 'displays the subscription form' do
      get :new, subtopic: @subtopic_slug

      assert_response :success
      assert_select ".signup-form"
    end
  end

  describe 'GET :new with an invalid subtopic' do
    it 'shows an error message' do
      get :new, subtopic: 'invalid/subtopic'

      assert_response :not_found
    end
  end

  describe 'POST :create with a valid email signup' do
    setup do
      @email_signup.stubs(:save).returns(true)
      @email_signup.expects(:subscription_url).returns('http://govdelivery_signup_url')
    end

    it 'registers the signup' do
      @email_signup.expects(:save).returns(true)

      post :create, subtopic: @subtopic_slug
    end

    it 'redirects to the govdelivery URL' do
      post :create, subtopic: @subtopic_slug

      assert_response :redirect
      assert_redirected_to 'http://govdelivery_signup_url'
    end
  end

  describe 'POST :create with an invalid email signup' do
    it "doesn't register the subscription" do
      @email_signup.expects(:save).never

      post :create, subtopic: 'invalid/subtopic'
    end

    it "404s" do
      post :create, subtopic: 'invalid/subtopic'

      assert_response :not_found
    end
  end
end
