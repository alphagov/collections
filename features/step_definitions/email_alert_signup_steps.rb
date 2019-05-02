Given(/^a topic subscription is expected$/) do
  stub_topic_lookups

  Services.email_alert_api
    .expects(:find_or_create_subscriber_list)
    .with(
      "title" => "Oil and Gas: Fields and Wells",
      "links" => {
        "topics" => ['content-id-for-fields-and-wells']
      }
    ).returns("subscriber_list" =>
       # This redirects to email-alert-api in real life, but force redirection to a fake path to verify redirect success
       { "subscription_url" => "/email_success" })
end

When(/^I access the email signup page via the topic$/) do
  visit "/topic/oil-and-gas/fields-and-wells/email-signup"
end

When(/^I sign up to the email alerts$/) do
  click_on "Create subscription"
end

Then(/^my subscription should be registered$/) do
  assert page.current_path == "/email_success"
end
