require 'integration_test_helper'

class OrganisationTest < ActionDispatch::IntegrationTest
  before do
    content_store_has_item('/government/organisations',
                           content_id: 'organisation-content-id',
                           title: 'Organisations',
                           base_path: '/government/organisations',
                           phase: 'live')
  end

  it "is possible to visit the organisations index page, which includes title" do
    visit "/government/organisations"
    assert page.has_title?("Departments, agencies and public bodies - GOV.UK")
  end

  it "is possible to visit the organisation page and return 200" do
    visit "/government/organisations"
    assert_equal 200, page.status_code
  end
end
