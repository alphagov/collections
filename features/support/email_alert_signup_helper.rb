require 'ostruct'

module EmailAlertSignupHelper
  def check_for_description_about(topic:, subtopic:)
    assert page.has_content?("e-mail alerts for the #{topic}: #{subtopic} topic")
  end

  def expect_registration_to(slug:, topic:, subtopic:)
    Collections.services(:email_alert_api)
      .expects(:find_or_create_subscriber_list)
      .with(
        "title" => "#{topic}: #{subtopic}",
        "tags" => {
          "topics" => [slug]
        }
      )
      .returns(OpenStruct.new("subscriber_list" => OpenStruct.new("subscription_url" => "/#{slug}")))
  end

  def subscribe_to_email_alerts
    click_on "Create subscription"
  end
end

World(EmailAlertSignupHelper)
