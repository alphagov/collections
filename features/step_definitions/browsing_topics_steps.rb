Given /^there are documents in a subtopic$/ do
  stub_topic_lookups
  collections_api_has_content_for("/oil-and-gas/fields-and-wells")
end

When /^I view the browse page for that subtopic$/ do
  visit "/oil-and-gas/fields-and-wells"
end

Then /^I see a list of organisations associated with content in the subtopic$/ do
  @organisations.each do |slug|
    assert page.has_selector?("a[href='/#{slug}'][class='organisation-link']")
  end
end
