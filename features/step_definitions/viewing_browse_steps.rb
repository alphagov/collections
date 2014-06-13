Given(/^there is an artefact tagged to a subsection$/) do
  stub_browse_sections(
    section: 'crime-and-justice',
    sub_section: 'judges',
    artefact: 'judge-dredd'
  )
end

Given(/^there is a detailed guidance category tagged to a subsection$/) do
  stub_detailed_guidance
end

Given(/^there is no detailed guidance category tagged to the subsection$/) do
  stub_404_detailed_guidance_response
end

When(/^I browse to the subsection$/) do
  browse_to_sub_section(section: 'Crime and justice', sub_section: 'Judges')
end

Then(/^I see the artefact listed/) do
  assert_can_see_linked_item('Judge dredd')
end

Then(/^I see the detailed guidance category listed$/) do
  assert_can_see_linked_item('Detailed guidance')
end
