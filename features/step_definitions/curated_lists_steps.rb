Given(/^there is curated content for a specialist sub\-sector$/) do
  stub_curated_lists_for("/oil-and-gas/fields-and-wells")
  stub_specialist_sector_tag_lookups
end

Then(/^I see a curated list of content$/) do
  assert_page_has_curated_lists
end
