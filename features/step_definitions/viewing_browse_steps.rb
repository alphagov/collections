CRIME_AND_JUSTICE_CONTENT_ID = SecureRandom::uuid
BENEFITS_CONTENT_ID = SecureRandom::uuid
JUDGES_CONTENT_ID = SecureRandom::uuid
COURTS_CONTENT_ID = SecureRandom::uuid

Given(/^there is an alphabetical browse page set up with links$/) do
  stub_browse_lookups

  second_level_browse_pages = [{
    content_id: JUDGES_CONTENT_ID,
    title: 'Judges',
    base_path: '/browse/crime-and-justice/judges',
    locale: :en,
  }]

  add_browse_pages
  add_first_level_browse_pages(
    child_pages: second_level_browse_pages,
    order_type: "alphabetical"
  )
  add_second_level_browse_pages(
    second_level_browse_pages,
    order_type: "alphabetical")
end

Given(/^that there are curated second level browse pages$/) do
  stub_browse_lookups

  second_level_browse_pages = [
    {
      content_id: JUDGES_CONTENT_ID,
      title: 'Judges',
      base_path: '/browse/crime-and-justice/judges',
      locale: :en,
    },
    {
      content_id: COURTS_CONTENT_ID,
      title: 'Courts',
      base_path: '/browse/crime-and-justice/courts',
      locale: :en,
    }
  ]

  add_browse_pages
  add_first_level_browse_pages(
    child_pages: second_level_browse_pages,
    order_type: "curated"
  )
  add_second_level_browse_pages(
    second_level_browse_pages,
    order_type: "curated")
end

Then(/^I see the links tagged to the browse page/) do
  assert page.has_selector?('a', text: "Judge Dredd")
end

When(/^I visit the main browse page$/) do
  visit browse_index_path
end

Then(/^I see the list of top level browse pages alphabetically ordered$/) do
  assert page.has_selector?("div#root li:nth-child(1)", text: "Benefits"), 'Benefits should appear first'
  assert page.has_selector?("div#root li:nth-child(2)", text: "Crime and justice"), 'Crime and justice should appear second'
end

When(/^I click on a top level browse page$/) do
  click_link 'Crime and justice'
end

Then(/^I see the list of second level browse pages$/) do
  assert page.has_selector?('a', text: 'Judges'), 'Subsection link should be visible'
end

Then(/^I see the curated list of second level browse pages$/) do
  assert page.has_selector?("div.curated li:nth-child(1)", text: "Judges"), 'Judges should appear first'
  assert page.has_selector?("div.curated li:nth-child(2)", text: "Courts"), 'Courts should appear second'
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

Then(/^the A to Z label should not be present$/) do
  assert page.has_no_content?('A to Z')
end

When(/^I visit that browse page$/) do
  visit '/browse/crime-and-justice/judges'
end

Then(/^I should see the topics linked under Detailed guidance$/) do
  assert page.has_content?('A linked topic')
end

def top_level_browse_pages
  [
    {
      content_id: CRIME_AND_JUSTICE_CONTENT_ID,
      title: 'Crime and justice',
      base_path: '/browse/crime-and-justice',
      locale: :en,
    },
    {
      content_id: BENEFITS_CONTENT_ID,
      title: 'Benefits',
      base_path: '/browse/benefits',
      locale: :en,
    },
  ]
end

def add_browse_pages
  browse_root = GovukSchemas::RandomExample
    .for_schema(frontend_schema: "mainstream_browse_page")
    .merge_and_validate({
      links: {
        top_level_browse_pages: top_level_browse_pages
      }
    })
  content_store_has_item("/browse", browse_root)
end

def add_first_level_browse_pages(child_pages:, order_type:)
  browse_page = GovukSchemas::RandomExample
    .for_schema(frontend_schema: "mainstream_browse_page")
    .merge_and_validate({
      base_path: '/browse/crime-and-justice',
      links: {
        top_level_browse_pages: top_level_browse_pages,
        second_level_browse_pages: child_pages,
      },
      details: {
        "second_level_ordering" => order_type,
        "ordered_second_level_browse_pages" => child_pages.map { |page| page[:content_id] }
      },
    })

  content_store_has_item("/browse/crime-and-justice", browse_page)
end

def add_second_level_browse_pages(second_level_browse_pages, order_type:)
  browse_page = GovukSchemas::RandomExample
    .for_schema(frontend_schema: "mainstream_browse_page")
    .merge_and_validate({
      content_id: JUDGES_CONTENT_ID,
      title: 'Judges',
      base_path: '/browse/crime-and-justice/judges',
      links: {
        top_level_browse_pages: top_level_browse_pages,
        second_level_browse_pages: second_level_browse_pages,
        active_top_level_browse_page: [{
          content_id: CRIME_AND_JUSTICE_CONTENT_ID,
          title: 'Crime and justice',
          base_path: '/browse/crime-and-justice',
          locale: :en,
        }],
        related_topics: [{
          content_id: SecureRandom::uuid,
          title: 'A linked topic',
          base_path: '/browse/linked-topic',
          locale: :en,
        }],
        mainstream_browse_content: [{
          content_id: SecureRandom::uuid,
          title: 'Judge Dredd',
          base_path: '/judge-dredd',
          locale: :en,
        }],
      },
      details: {
        "second_level_ordering" => order_type,
      },
    })

  content_store_has_item("/browse/crime-and-justice/judges", browse_page)
end
