Given(/^there is latest content for a subtopic$/) do
  stub_topic_lookups
  stub_latest_changes
end

When(/^I view the latest changes page for that subtopic$/) do
  visit "/topic/oil-and-gas/fields-and-wells/latest"
end

Then(/^I see a date\-ordered list of content with change notes$/) do
  results = subtopic_slugs.map.with_index do |slug, i|
    search_api_document_for_slug(slug, (i + 1).hours.ago)
  end

  results.each_with_index do |document, index|
    within(".gem-c-document-list__item:nth-of-type(#{index + 1})") do
      assert page.has_selector?("a[href='#{document['link']}']", text: document["title"])
      assert page.has_content?(document["latest_change_note"]) if document["latest_change_note"]
      assert page.has_selector?("time") if document["public_updated_at"]
    end
  end
end
