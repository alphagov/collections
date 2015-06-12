Given(/^there is latest content for a subtopic$/) do
  collections_api_has_content_for("/oil-and-gas/fields-and-wells")
  stub_topic_lookups
end

When(/^I view the latest changes page for that subtopic$/) do
  visit "/oil-and-gas/fields-and-wells/latest"
end

Then(/^I see a date\-ordered list of content with change notes$/) do
  collections_api_example_documents.each_with_index do |document, index|
    within(".browse-container li:nth-of-type(#{index+1})") do
      assert page.has_selector?("h3 a[href='#{document[:link]}']", text: document[:title])
      assert page.has_content?(document[:latest_change_note]) if document[:latest_change_note]
      assert page.has_selector?("time") if document[:public_updated_at]
    end
  end
end
