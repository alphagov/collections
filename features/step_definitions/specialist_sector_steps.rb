Given /^there are documents in a specialist sub-sector$/ do
  stub_specialist_sector_tag_lookups
end

When /^I view the browse page for that sub-sector$/ do
  visit_specialist_sector_topic
end

Then /^I see the specialist sector documents$/ do
  assert_presence_of_specialist_sector_content
end

Then /^I see a list of organisations associated with content in the sub-sector$/ do
  assert_presence_of_organisations
end


