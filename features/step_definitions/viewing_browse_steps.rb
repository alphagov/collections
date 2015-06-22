Given(/^there is a browse page set up with links$/) do
  stub_browse_sections(
    section: 'crime-and-justice',
    sub_section: 'judges',
    artefact: 'judge-dredd'
  )
end

Given(/^the page also has detailed guidance links$/) do
  stub_detailed_guidance
end

Given(/^there is no detailed guidance category tagged to the page$/) do
  stub_request(:get, "#{Plek.current.find('whitehall-admin')}/api/specialist/tags.json?parent_id=crime-and-justice/judges&type=section").to_raise(GdsApi::HTTPNotFound)
  content_store_has_item '/browse/crime-and-justice/judges', { links: {} }
end

Then(/^I see the links tagged to the browse page/) do
  assert_can_see_linked_item('Judge dredd')
end

Then(/^I should see the detailed guidance links$/) do
  assert_can_see_linked_item('Detailed guidance')
end

When(/^I visit the main browse page$/) do
  visit browse_path
end

When(/^I click on a top level browse page$/) do
  click_link 'Crime and justice'
end

Then(/^I see the list of second level browse pages$/) do
  assert page.has_selector?('a', text: 'Judges'), 'Subsection link should be visible'
end

When(/^I click on a second level browse page$/) do
  click_link 'Judges'
end

Then(/^I should see the second level browse page$/) do
  assert page.has_selector?('h1', text: 'Judges')
end
