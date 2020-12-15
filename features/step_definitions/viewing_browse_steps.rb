Given(/^there is an alphabetical browse page set up with links$/) do
  second_level_browse_pages = [{
    content_id: "judges-content-id",
    title: "Judges",
    base_path: "/browse/crime-and-justice/judges",
  }]

  add_browse_pages
  add_first_level_browse_pages(
    child_pages: second_level_browse_pages,
    order_type: "alphabetical",
  )
  add_second_level_browse_pages(second_level_browse_pages)

  rummager_has_documents_for_browse_page(
    "judges-content-id",
    %w[
      judge-dredd
    ],
    page_size: RummagerSearch::PAGE_SIZE_TO_GET_EVERYTHING,
  )
end

Given(/^that there are curated second level browse pages$/) do
  second_level_browse_pages = [
    {
      content_id: "judges-content-id",
      title: "Judges",
      base_path: "/browse/crime-and-justice/judges",
    },
    {
      content_id: "courts-content-id",
      title: "Courts",
      base_path: "/browse/crime-and-justice/courts",
    },
  ]

  add_browse_pages
  add_first_level_browse_pages(
    child_pages: second_level_browse_pages,
    order_type: "curated",
  )
  add_second_level_browse_pages(second_level_browse_pages)
end

Then(/^I see the links tagged to the browse page/) do
  assert page.has_selector?("a", text: "Judge dredd")
end

When(/^I visit the main browse page$/) do
  visit browse_index_path
end

Then(/^I see the list of top level browse pages alphabetically ordered$/) do
  assert page.has_selector?("div#root li:nth-child(1)", text: "Benefits"), "Benefits should appear first"
  assert page.has_selector?("div#root li:nth-child(2)", text: "Crime and justice"), "Crime and justice should appear second"
end

When(/^I click on a top level browse page$/) do
  click_link "Crime and justice"
end

Then(/^I see the list of second level browse pages$/) do
  assert page.has_selector?("a", text: "Judges"), "Subsection link should be visible"
end

Then(/^I see the curated list of second level browse pages$/) do
  assert page.has_selector?("div.curated li:nth-child(1)", text: "Judges"), "Judges should appear first"
  assert page.has_selector?("div.curated li:nth-child(2)", text: "Courts"), "Courts should appear second"
end

When(/^I click on a second level browse page$/) do
  click_link "Judges"
end

Then(/^I should see the second level browse page$/) do
  assert page.has_selector?("h2", text: "Judges")
end

Then(/^the A to Z label should be present$/) do
  assert page.has_content?("A to Z")
end

Then(/^the A to Z label should not be present$/) do
  assert page.has_no_content?("A to Z")
end

When(/^I visit that browse page$/) do
  visit "/browse/crime-and-justice/judges"
end

Then(/^I should see the topics linked under Detailed guidance$/) do
  assert page.has_content?("A linked topic")
end

def top_level_browse_pages
  [
    {
      content_id: "content-id-for-crime-and-justice",
      title: "Crime and justice",
      base_path: "/browse/crime-and-justice",
    },
    {
      content_id: "content-id-for-benefits",
      title: "Benefits",
      base_path: "/browse/benefits",
    },
  ]
end

def add_browse_pages
  stub_content_store_has_item "/browse",
                              links: {
                                top_level_browse_pages: top_level_browse_pages,
                              }
end

def add_first_level_browse_pages(child_pages:, order_type:)
  stub_content_store_has_item(
    "/browse/crime-and-justice",
    base_path: "/browse/crime-and-justice",
    title: "Crime and Justice",
    links: {
      top_level_browse_pages: top_level_browse_pages,
      second_level_browse_pages: child_pages,
    },
    details: {
      second_level_ordering: order_type,
      ordered_second_level_browse_pages: child_pages.map { |page| page[:content_id] },
    },
  )
end

def add_second_level_browse_pages(second_level_browse_pages)
  stub_content_store_has_item "/browse/crime-and-justice/judges",
                              content_id: "judges-content-id",
                              title: "Judges",
                              base_path: "/browse/crime-and-justice/judges",
                              links: {
                                top_level_browse_pages: top_level_browse_pages,
                                second_level_browse_pages: second_level_browse_pages,
                                active_top_level_browse_page: [{
                                  content_id: "content-id-for-crime-and-justice",
                                  title: "Crime and justice",
                                  base_path: "/browse/crime-and-justice",
                                }],
                                related_topics: [{ title: "A linked topic", base_path: "/browse/linked-topic" }],
                              }
end
