Given(/^a topic$/) do
  stub_specialist_sector_tag_lookups
  stub_curated_lists_for("/oil-and-gas/fields-and-wells")
end

When(/^I access the email signup page via the topic$/) do
  ## Since we don't have a latest page yet,
  ## this behaviour is being simulated by going direct to the signup page.
  # visit_latest_page("oil-and-gas/fields-and-wells")
  # follow_email_signup_link

  visit email_signup_path(subtopic: "oil-and-gas/fields-and-wells")
end

When(/^I sign up to the email alerts$/) do
  subscribe_to_email_alerts
end

Then(/^my subscription should be registered$/) do
  expect_registration_to(slug: "oil-and-gas/fields-and-wells", topic: "Oil and gas", subtopic: "Example title")
end
