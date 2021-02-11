Given(/^there are documents in a topic$/) do
  stub_services_and_information_lookups
end

When(/^I view the services and information page for the organisation$/) do
  visit "/government/organisations/hm-revenue-customs/services-information"
end

Then(/^I see a list of links associated with content in the topic$/) do
  @services_and_information.each do |slug|
    expect(page).to have_selector("a[href='/#{slug}']")
  end
end
