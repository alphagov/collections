require "test_helper"
require "ostruct"

describe EmailSignup do
  setup do
    @subtopic = mock
    @subtopic.stubs(slug: "oil-and-gas/wells", content_id: "uuid-888")
    @subtopic.stubs(combined_title: "Oil and gas: Wells")

    @request = stub_request(:get, "https://email-alert-api.test.gov.uk/subscriber-lists?links%5Btopics%5D%5B0%5D=uuid-888")
      .to_return(
        body: {
          subscriber_list: {
            subscription_url: "http://email_alert_api_signup_url",
          },
        }.to_json,
      )
  end

  it "is invalid with no subtopic" do
    assert_not EmailSignup.new(nil).valid?
  end

  describe "#save" do
    it "creates the topic in email-alert-api using the subtopic slug and combined title" do
      email_signup = EmailSignup.new(@subtopic)
      assert email_signup.save
      assert_requested @request
    end

    it "does not create a subscription if the subtopic is missing" do
      Services.email_alert_api.expects(:find_or_create_subscriber_list).never

      assert_not EmailSignup.new(nil).save
    end
  end

  describe "#subscription_url" do
    it "is the subscription_url returned by the API" do
      email_signup = EmailSignup.new(@subtopic)
      email_signup.save

      assert_equal "http://email_alert_api_signup_url", email_signup.subscription_url
    end
  end
end
