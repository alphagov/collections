require 'integration_test_helper'

class OrganisationTest < ActionDispatch::IntegrationTest
  before do
    @content_item = {
        title: "Prime Minister's Office, 10 Downing Street",
        base_path: "/government/organisations/prime-ministers-office-10-downing-street",
        details: {}
    }

    content_store_has_item('/government/organisations/prime-ministers-office-10-downing-street', @content_item)
  end

  it "is possible to visit the organisations index page, which includes title" do
    visit "/government/organisations/prime-ministers-office-10-downing-street"
    assert page.has_title?("Prime Minister's Office, 10 Downing Street - GOV.UK")
  end

  it "is possible to visit the organisation page and return 200" do
    visit "/government/organisations/prime-ministers-office-10-downing-street"
    assert_equal 200, page.status_code
  end

  it "displays the organisation title" do
    visit "/government/organisations/prime-ministers-office-10-downing-street"
    assert page.has_content?(@content_item[:title])
  end

  it "current path matches base path" do
    visit "/government/organisations/prime-ministers-office-10-downing-street"
    assert_equal page.current_path, @content_item[:base_path]
  end
end
