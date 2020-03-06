Given(/^there are topic content items$/) do
  stub_topic_lookups
end

When(/^I visit the topic browse page$/) do
  visit "/topic"
end

Then(/^I click on topic (.*)$/) do |topic_link|
  click_on topic_link
end

Then(/^the eCommerce tracking tags are present for the topics root node$/) do
  list_has_ecommerce_attributes("#content > div > nav.topics", "Topic browse", "topic index")
  list_items_have_ecommerce_tracking_attributes("#content > div > nav.topics li", topics_root_node_search_data, "a")
end

Then(/^the eCommerce tracking tags are present for the topics branch node$/) do
  list_has_ecommerce_attributes("#content > div > nav.topics", "Topic browse", "oil and gas")
  list_items_have_ecommerce_tracking_attributes("#content > div > nav.topics li", topics_branch_node_search_data, "a")
end

Then(/^the eCommerce tracking tags are present for a curated topic leaf node$/) do
  assert_equal page.find_all("#content > div > nav.govuk-grid-row").count, 2
  leaf_node_ecommerce_tracking_is_present("#content > div > nav.govuk-grid-row", "Topic browse", topics_leaf_node_search_data[0])
end

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
  assert_equal page.find(css_selector)["data-ecommerce-start-index"], start_index.to_s
  assert_equal page.find(css_selector)["data-list-title"], list_title
  assert_equal page.find(css_selector)["data-search-query"], list_subtitle
end

def leaf_node_ecommerce_tracking_is_present(groups_css_selector, list_title, topic_fixtures, start_index = 1)
  page.find_all(groups_css_selector).each.with_index do |nav_group, nav_index|
    group_fixture = topic_fixtures[:details][:groups][nav_index]
    list_has_ecommerce_attributes("#{groups_css_selector}:nth-child(#{nav_index + 1})", list_title, group_fixture[:name])
    group_css_selector = "#{groups_css_selector}:nth-child(#{nav_index + 1})"
    nav_group.find_all("li").each.with_index do |list_item, list_item_index|
      list_item_css_selector = "#{group_css_selector} li:nth-child(#{list_item_index + 1}) a"
      expected_href = group_fixture[:contents][list_item_index]
      assert_equal page.find(list_item_css_selector)["data-ecommerce-row"], (list_item_index + start_index).to_s
      assert_equal page.find(list_item_css_selector)["data-ecommerce-path"], expected_href
    end
  end
end

def topic_leaf_nodes_have_ecommerce_tracking_attributes(group_list_selector, list_items, list_element, start_index = 1)
  alphabetised_groups = list_items[:details][:groups].sort_by { |item| item[:name] }
  alphabetised_groups.each.with_index do |group, group_index|
    group_row_selector = "#{}:nth-child(#{group_index}) li"
    group[:contents].each.with_index do |document_path, index|
      css_selector = "#{css_list_selector}:nth-child(#{index + 1}) #{list_element}"
      assert_equal page.find(css_selector)["data-ecommerce-row"], (index + start_index).to_s
      puts page.find(css_selector)["data-ecommerce-path"]
      puts document_path
      puts group[:contents]
      puts css_selec
      assert_equal page.find(css_selector)["data-ecommerce-path"], document_path
    end
  end
end

def list_items_have_ecommerce_tracking_attributes(css_list_selector, list_items, list_element, start_index = 1)
  list_items.each.with_index do |list_item, index|
    css_selector = "#{css_list_selector}:nth-child(#{index + 1}) #{list_element}"
    assert_equal page.find(css_selector)["data-ecommerce-row"], (index + start_index).to_s
    assert_equal page.find(css_selector)["data-ecommerce-path"], list_item[:base_path]
  end
end

def tracking_options_payloads
  [
    '{"dimension28":"2","dimension29":"Benefits"}',
    '{"dimension28":"2","dimension29":"Crime and justice"}',
  ]
end

def topics_root_node_search_data
  [
    {
      content_id: "/topic/oil-and-gas",
      title: "Oil and Gas",
      base_path: "/topic/oil-and-gas",
    }
  ]
end

def topics_branch_node_search_data
  [
    {
      content_id: "/topic/oil-and-gas/fields-and-wells",
      title: "Fields and wells",
      base_path: "/topic/oil-and-gas/fields-and-wells",
    }
  ]
end

def topics_leaf_node_search_data
  [
    {
      content_id: "/topic/oil-and-gas/fields-and-wells",
      title: "Fields and Wells",
      base_path: "/topic/oil-and-gas/fields-and-wells",
      details: {
        groups: [
          {
            name: "Oil rigs",
            contents: [
              "/what-is-oil",
              "/apply-for-an-oil-licence",
            ]
          },
          {
            name: "Piping",
            contents: [
              "/well-application-form",
            ]
          },
        ],
      },
    },
  ]
end
