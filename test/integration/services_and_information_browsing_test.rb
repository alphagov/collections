require "integration_test_helper"

class ServicesAndInformationBrowsingTest < ActionDispatch::IntegrationTest
  include SearchApiHelpers
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

    within ".govuk-grid-row:nth-child(1) h2" do
      assert page.has_content?("Environmental permits")
    end

    within ".govuk-grid-row:nth-child(2) h2" do
      assert page.has_content?("Waste")
    end

    assert page.has_css?(".gem-c-breadcrumbs")
  end

  it "includes tracking attributes on all links" do
    visit "/government/organisations/hm-revenue-customs/services-information"

    assert page.has_selector?('.browse-container[data-module="gem-track-click"]')

    within ".govuk-grid-row:first-child .app-c-topic-list" do
      content_item_link = page.first("li a")

      assert_equal(
        "navServicesInformationLinkClicked",
        content_item_link["data-track-category"],
        "Expected a tracking category to be set in the data attributes",
      )

      assert_equal(
        "1.1",
        content_item_link["data-track-action"],
        "Expected the link position to be set in the data attributes",
      )

      assert_equal(
        content_item_link[:href],
        content_item_link["data-track-label"],
        "Expected the content item base path to be set in the data attributes",
      )

      assert content_item_link["data-track-options"].present?

      data_options = JSON.parse(content_item_link["data-track-options"])
      assert_equal(
        page.all("li a").count.to_s,
        data_options["dimension28"],
        "Expected the total number of content items within the section to be present in the tracking options",
      )

      assert_equal(
        content_item_link.text,
        data_options["dimension29"],
        "Expected the content item title to be present in the tracking options",
      )
    end

    within ".govuk-grid-row:nth-child(2) .app-c-topic-list" do
      content_item_link = page.first("li a")

      assert_equal(
        "navServicesInformationLinkClicked",
        content_item_link["data-track-category"],
        "Expected a tracking category to be set in the data attributes",
      )

      assert_equal(
        "2.1",
        content_item_link["data-track-action"],
        "Expected the link position to be set in the data attributes",
      )

      assert_equal(
        content_item_link[:href],
        content_item_link["data-track-label"],
        "Expected the content item base path to be set in the data attributes",
      )

      assert content_item_link["data-track-options"].present?

      data_options = JSON.parse(content_item_link["data-track-options"])
      assert_equal(
        page.all("li a").count.to_s,
        data_options["dimension28"],
        "Expected the total number of content items within the section to be present in the tracking options",
      )

      assert_equal(
        content_item_link.text,
        data_options["dimension29"],
        "Expected the content item title to be present in the tracking options",
      )
    end
  end
end
