Given(/^there is curated content for a subtopic$/) do
  collections_api_has_content_for("/oil-and-gas/fields-and-wells")
  stub_topic_lookups
end

Then(/^I see a curated list of content$/) do
  assert page.has_selector?("h1", text: "Oil rigs")
  assert page.has_selector?("h1", text: "Piping")
end
