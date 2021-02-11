Given(/^there is curated content for a subtopic$/) do
  stub_topic_lookups
end

Then(/^I see a curated list of content$/) do
  expect(page).to have_selector("h2", text: "Oil rigs")
  expect(page).to have_selector("h2", text: "Piping")
end
