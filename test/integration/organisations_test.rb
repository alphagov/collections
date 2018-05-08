require 'integration_test_helper'

class OrganisationTest < ActionDispatch::IntegrationTest
  before do
    @content_item = {
        content_id: 'organisation-content-id',
        title: 'Organisations',
        base_path: '/government/organisations',
        phase: 'live',
        organisation: 'Cabinet Office',
        department_type: 'Ministerial'
    }
    content_store_has_item('/government/organisations', @content_item)
  end

  before { visit "/government/organisations" }

  it "is possible to visit the organisations index page, which includes title" do
    assert page.has_title?("Departments, agencies and public bodies - GOV.UK")
  end

  it "is possible to visit the organisation page and return 200" do
    assert_equal 200, page.status_code
  end

  it "is possible to see a list of organisations" do
    assert_includes page.body, @content_item[:organisation]
  end

  it "displays Ministerial department in the right section" do
    assert page.has_css?('h2:first', text: "Ministerial")
  end

  it "displays Non Ministerial department in the right section" do
    assert page.has_css?('h2:nth-of-type(2)', text: "Non Ministerial")
  end
end
