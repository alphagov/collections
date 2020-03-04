Then(/^the eCommerce tracking tags are present in mainstream browse level (\w*)$/) do |browse_level|
  case browse_level
  when "first_level"
    # First level only
    list_has_ecommerce_attributes("div#root", "Mainstream browse", "all categories")
    list_items_have_ecommerce_tracking_attributes("div#root li", top_level_browse_pages, "a")
  when "second_level"
    # Second level AND first level
    list_has_ecommerce_attributes("div#root", "Mainstream browse", "all categories")
    list_items_have_ecommerce_tracking_attributes("div#root li", top_level_browse_pages, "a")

    list_has_ecommerce_attributes("#section > div", "Mainstream browse", "crime and justice")
    list_items_have_ecommerce_tracking_attributes("#section > div li", second_level_browse_pages, "a")
  when "third_level"
    # Third level AND previous two levels
    list_has_ecommerce_attributes("div#root", "Mainstream browse", "all categories")
    list_items_have_ecommerce_tracking_attributes("div#root li", top_level_browse_pages, "a")

    list_has_ecommerce_attributes("#section > div", "Mainstream browse", "crime and justice")
    list_items_have_ecommerce_tracking_attributes("#section > div li", second_level_browse_pages, "a")

    list_has_ecommerce_attributes("#subsection > div > ul", "Mainstream browse", "crime and justice")
    list_items_have_ecommerce_tracking_attributes("#subsection > div > ul li", third_level_browse_documents, "a")
  else
    false
  end
end

And(/^the links on the page have tracking attributes at browse level (\w*)$/) do |browse_level|
  list_items_have_click_tracking_attributes("div#root li", top_level_browse_pages, "a", browse_level)
end

private

def list_items_have_click_tracking_attributes(css_list_selector, list_items, list_element, browse_level)
  alphabetised_list = list_items.sort_by { |item| item[:title] }
  alphabetised_list.each.with_index(1) do |list_item, index|
    css_selector = "#{css_list_selector}:nth-child(#{index}) #{list_element}"
    assert_equal page.find(css_selector)["data-track-action"], index.to_s
    assert_equal page.find(css_selector)["data-track-label"], list_item[:base_path]
    assert_equal page.find(css_selector)["data-track-category"], track_category(browse_level)
    assert_equal page.find(css_selector)["data-track-options"], tracking_options_payloads[index - 1]
  end
end

def track_category(browse_level)
  return "firstLevelBrowseLinkClicked" if browse_level == "one"
  return "secondLevelBrowseLinkClicked" if browse_level == "two"
  return "thirdLevelBrowseLinkClicked" if browse_level == "three"

  "Invalid browse level"
end

def list_has_ecommerce_attributes(css_selector, list_title, list_subtitle, start_index = 1)
  assert page.has_selector?("#{css_selector}[data-analytics-ecommerce]")
  assert_equal page.find?(css_selector)["data-ecommerce-start-index"], start_index
  assert_equal page.find?(css_selector)["data-list-title"], list_title
  assert_equal page.find?(css_selector)["data-search-query"], list_subtitle
end

def list_items_have_ecommerce_tracking_attributes(css_list_selector, list_items, list_element, start_index = 1)
  list_items.each.with_index do |list_item, index|
    css_selector = "#{css_list_selector}:nth-child(#{index}) #{list_element}"
    assert_equal page.find(css_selector)["data-ecommerce-row"], (index + start_index).to_s
    assert_equal page.find(css_selector)["data-ecommerce-path"], list_item.base_path
  end
end

def tracking_options_payloads
  [
    '{"dimension28":"2","dimension29":"Benefits"}',
    '{"dimension28":"2","dimension29":"Crime and justice"}',
  ]
end
