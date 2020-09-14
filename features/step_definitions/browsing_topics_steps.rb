Given(/^there are documents in a subtopic$/) do
  stub_topic_lookups
end

When(/^I view the browse page for that subtopic$/) do
  visit "/topic/oil-and-gas/fields-and-wells"
end

Then(/^I see a list of organisations associated with content in the subtopic$/) do
  within "#subtopic-metadata" do
    assert page.has_text?("Department of Energy & Climate Change")
  end
end
