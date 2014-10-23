require 'test_helper'
require 'ostruct'

describe EmailSignup do
  setup do
    @subtopic = mock
    @subtopic.stubs(slug: "oil-and-gas/wells")
    @subtopic.stubs(combined_title: "Oil and gas: Wells")

    collections_api_has_curated_lists_for("/#{@subtopic.slug}")

    @email_alert_api = mock
    Collections.services(:email_alert_api, @email_alert_api)

    @email_alert_api.stubs(:find_or_create_subscriber_list).returns(OpenStruct.new("subscriber_list" => OpenStruct.new("subscription_url" => "http://govdelivery_signup_url")))
  end

  it "is invalid with no subtopic" do
    refute EmailSignup.new(nil).valid?
  end

  describe "#save" do
    it "creates the topic in GovDelivery using the subtopic slug and combined title" do
      email_signup = EmailSignup.new(@subtopic)

      @email_alert_api.expects(:find_or_create_subscriber_list).with(
        "title" => "Oil and gas: Wells",
        "tags" => {
          "topic" => ["oil-and-gas/wells"]
        }
      ).returns(OpenStruct.new("subscriber_list" => OpenStruct.new("subscription_url" => "http://govdelivery_signup_url")))

      assert email_signup.save
    end

    it "does not create a subscription if the subtopic is missing" do
      @email_alert_api.expects(:find_or_create_subscriber_list).never

      refute EmailSignup.new(nil).save
    end
  end

  describe "#subscription_url" do
    it "is the subscription_url returned by the API" do
      email_signup = EmailSignup.new(@subtopic)
      email_signup.save

      assert_equal "http://govdelivery_signup_url", email_signup.subscription_url
    end
  end
end
