Then(/^the ecommerce tracking tags are present$/) do
  assert page.has_selector?("div#root[data-analytics-ecommerce]")
  assert page.has_selector?("div#root[data-search-query]")
  assert page.has_selector?('div#root[data-ecommerce-start-index="1"]')
  assert page.has_selector?('div#root[data-list-title="Mainstream browse - Column 1"]')
  assert page.has_selector?("div#root li:nth-child(1) a[data-ecommerce-row]")
  assert page.has_selector?("div#root li:nth-child(2) a[data-ecommerce-row]")

  assert_equal page.find("div#root li:nth-child(1) a")["data-ecommerce-row"], "1"
  assert_equal page.find("div#root li:nth-child(1) a")["data-ecommerce-path"], "/browse/benefits"

  assert_equal page.find("div#root li:nth-child(2) a")["data-ecommerce-row"], "2"
  assert_equal page.find("div#root li:nth-child(2) a")["data-ecommerce-path"], "/browse/crime-and-justice"
end

And(/^the links on the page have tracking attributes$/) do
  assert_equal page.find("div#root li:nth-child(1) a")["data-track-action"], "1"
  assert_equal page.find("div#root li:nth-child(1) a")["data-track-label"], "/browse/benefits"
  assert_equal page.find("div#root li:nth-child(1) a")["data-track-category"], "firstLevelBrowseLinkClicked"
  assert_equal page.find("div#root li:nth-child(1) a")["data-track-options"], tracking_options_payloads[0]

  assert_equal page.find("div#root li:nth-child(2) a")["data-track-action"], "2"
  assert_equal page.find("div#root li:nth-child(2) a")["data-track-label"], "/browse/crime-and-justice"
  assert_equal page.find("div#root li:nth-child(2) a")["data-track-category"], "firstLevelBrowseLinkClicked"
  assert_equal page.find("div#root li:nth-child(2) a")["data-track-options"], tracking_options_payloads[1]
end

def tracking_options_payloads
  [
    '{"dimension28":"2","dimension29":"Benefits"}',
    '{"dimension28":"2","dimension29":"Crime and justice"}',
  ]
end
