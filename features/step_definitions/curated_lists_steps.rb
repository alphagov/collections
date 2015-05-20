Given(/^there is curated content for a subtopic$/) do
  stub_curated_lists_for("/oil-and-gas/fields-and-wells")
  stub_topic_lookups
end

Then(/^I see a curated list of content$/) do
  assert_page_has_curated_lists
end
