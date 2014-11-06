Given(/^there is latest content for a specialist sub\-sector$/) do
  stub_latest_changes_for("/oil-and-gas/fields-and-wells")
  stub_specialist_sector_tag_lookups
end

When(/^I view the latest changes page for that sub\-sector$/) do
  visit_latest_changes_for("/oil-and-gas/fields-and-wells")
end

Then(/^I see a date\-ordered list of content with change notes$/) do
  assert_page_has_date_ordered_latest_changes
end
