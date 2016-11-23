require 'integration_test_helper'

class ServicesAndInformationBrowsingTest < ActionDispatch::IntegrationTest
  include RummagerHelpers
  include ServicesAndInformationHelpers

  before do
    stub_services_and_information_links("hm-revenue-customs")
    stub_services_and_information_content_item
  end

  it "is possible to visit the services and information index page" do
    visit "/government/organisations/hm-revenue-customs/services-information"

    assert page.has_title?("Services and information - HM Revenue & Customs - GOV.UK")

    within "header.page-header" do
      assert page.has_content?("Services and information")
    end

    within "nav.index-list:nth-child(1) h1" do
      assert page.has_content?("Environmental permits")
    end

    within "nav.index-list:nth-child(2) h1" do
      assert page.has_content?("Waste")
    end

    assert page.has_selector?(shared_component_selector('breadcrumbs'))
  end
end
