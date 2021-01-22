Given(/^there is latest content for a subtopic$/) do
  stub_topic_lookups

  @stubbed_rummager_documents = %w[
    what-is-oil
    apply-for-an-oil-licence
    environmental-policy
    onshore-exploration-and-production
    well-application-form
    well-report-2014
    oil-extraction-count-2013
  ].map.with_index do |slug, i|
    {
      "latest_change_note" => "This has changed",
      "public_timestamp" => (i + 1).hours.ago.iso8601,
      "title" => slug.titleize.to_s,
      "link" => "/government/publications/#{slug}",
      "index" => "government",
      "_id" => "/government/publications/#{slug}",
      "document_type" => "edition",
    }
  end
  Services.rummager.stubs(:search).with(
    has_entries(
      start: 0,
      count: 50,
      filter_topic_content_ids: %w[content-id-for-fields-and-wells],
      order: "-public_timestamp",
    ),
  ).returns("results" => @stubbed_rummager_documents,
            "start" => 0,
            "total" => @stubbed_rummager_documents.size)
end

When(/^I view the latest changes page for that subtopic$/) do
  visit "/topic/oil-and-gas/fields-and-wells/latest"
end

Then(/^I see a date\-ordered list of content with change notes$/) do
  @stubbed_rummager_documents.each_with_index do |document, index|
    within(".gem-c-document-list__item:nth-of-type(#{index + 1})") do
      assert page.has_selector?("a[href='#{document['link']}']", text: document["title"])
      assert page.has_content?(document["latest_change_note"]) if document["latest_change_note"]
      assert page.has_selector?("time") if document["public_updated_at"]
    end
  end
end
