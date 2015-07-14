Given(/^there is an? (\w+) browse page set up with links$/) do |second_level_ordering|
  top_level_browse_pages = [{ title: 'Crime and justice', base_path: '/browse/crime-and-justice' }]
  second_level_browse_pages = [{ title: 'Judges', base_path: '/browse/crime-and-justice/judges' }]

  content_store_has_item '/browse', { links: {
    top_level_browse_pages: top_level_browse_pages
    }
  }

  content_store_has_item('/browse/crime-and-justice', {
    base_path: '/browse/crime-and-justice',
    links: {
      top_level_browse_pages: top_level_browse_pages,
      second_level_browse_pages: second_level_browse_pages,
    },
    details: {
      second_level_ordering: second_level_ordering,
    },
  })

  content_store_has_item '/browse/crime-and-justice/judges', {
    title: 'Judges',
    base_path: '/browse/crime-and-justice/judges',
    links: {
      top_level_browse_pages: top_level_browse_pages,
      second_level_browse_pages: second_level_browse_pages,
      active_top_level_browse_page: [{ title: 'Crime and justice', base_path: '/browse/crime-and-justice' }]
    }
  }

  stub_request(:get, "https://contentapi.test.gov.uk/tags/crime-and-justice%2Fjudges.json").
    to_return(:status => 200, :body => "{}", :headers => {})

  stub_request(:get, "https://contentapi.test.gov.uk/with_tag.json?section=crime-and-justice/judges").
    to_return(:status => 200, :body => JSON.dump(results: [{title: 'Judge dredd', web_url: 'http://gov.uk/judge'}]))
end

Given(/^the page also has detailed guidance links$/) do
  stub_detailed_guidance
end

Given(/^there is no detailed guidance category tagged to the page$/) do
  stub_request(:get, "#{Plek.current.find('whitehall-admin')}/api/specialist/tags.json?parent_id=crime-and-justice/judges&type=section").to_raise(GdsApi::HTTPNotFound)
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

Then(/^the A to Z label should be present$/) do
  assert page.has_content?('A to Z')
end

Then(/^the A to Z label should be not present$/) do
  assert page.has_no_content?('A to Z')
end
