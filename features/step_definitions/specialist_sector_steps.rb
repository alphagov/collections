Given /^there are documents in a subtopic$/ do
  stub_specialist_sector_tag_lookups
  stub_curated_lists_for("/oil-and-gas/fields-and-wells")
end

When /^I view the browse page for that subtopic$/ do
  visit_specialist_sector_topic
end

Then /^I see a list of organisations associated with content in the subtopic$/ do
  assert_presence_of_organisations
end
