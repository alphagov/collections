Given(/^a topic$/) do
  stub_topic_lookups
end

When(/^I access the email signup page via the topic$/) do
  visit email_signup_path(topic_slug: "oil-and-gas", subtopic_slug: "fields-and-wells")
end

When(/^I sign up to the email alerts$/) do
  click_on "Create subscription"
end

Then(/^my subscription should be registered$/) do
  Collections.services(:email_alert_api)
    .expects(:find_or_create_subscriber_list)
    .with(
      "title" => "Oil and Gas: Fields and Wells",
      "tags" => {
        "topics" => ["oil-and-gas/fields-and-wells"]
      }
    ).returns(OpenStruct.new("subscriber_list" => OpenStruct.new("subscription_url" => "/oil-and-gas/fields-and-wells")))
end
