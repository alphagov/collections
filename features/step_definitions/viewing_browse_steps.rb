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
      active_top_level_browse_page: [{ title: 'Crime and justice', base_path: '/browse/crime-and-justice' }],
      related_topics: [{ title: 'A linked topic', base_path: '/browse/linked-topic' }]
    }
  }

  stub_request(:get, "https://contentapi.test.gov.uk/tags/crime-and-justice%2Fjudges.json").
    to_return(:status => 200, :body => "{}", :headers => {})

  stub_request(:get, "https://contentapi.test.gov.uk/with_tag.json?section=crime-and-justice/judges").
    to_return(:status => 200, :body => JSON.dump(results: [{title: 'Judge dredd', web_url: 'http://gov.uk/judge'}]))
end

Then(/^I see the links tagged to the browse page/) do
  assert_can_see_linked_item('Judge dredd')
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

When(/^I visit that browse page$/) do
  visit '/browse/crime-and-justice/judges'
end

Then(/^I should see the topics linked under Detailed guidance$/) do
  assert page.has_content?('A linked topic')
end
