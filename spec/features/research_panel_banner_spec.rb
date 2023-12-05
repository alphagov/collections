require "integration_spec_helper"

RSpec.feature "Research panel banner" do
  include SearchApiHelpers
  include RecruitmentBannerHelper

  scenario "browse pages where we want to display User Research banner" do
    schema = GovukSchemas::Example.find("mainstream_browse_page", example_name: "level_2_page")

    survey_url = "https://surveys.publishing.service.gov.uk/s/ur-ttm/"

    pages_of_interest =
      [
        "/browse/business/setting-up",
        "/browse/business/business-tax",
        "/browse/business/finance-support",
        "/browse/business/limited-company",
        "/browse/business/expenses-employee-benefits",
        "/browse/business/funding-debt",
        "/browse/business/premises-rates",
        "/browse/business/food",
        "/browse/business/imports",
        "/browse/business/exports",
        "/browse/business/licences",
        "/browse/business/selling-closing",
        "/browse/business/sale-goods-services-data",
        "/browse/business/childcare-providers",
        "/browse/business/manufacturing",
        "/browse/business/intellectual-property",
        "/browse/business/waste-environment",
        "/browse/business/science",
        "/browse/business/maritime",
        "/browse/business",
      ]

    pages_of_interest.each do |path|
      schema["base_path"] = path
      stub_content_store_has_item(schema["base_path"], schema.to_json)
      search_api_has_documents_for_browse_page(schema["content_id"], [schema["base_path"]], page_size: SearchApiSearch::PAGE_SIZE_TO_GET_EVERYTHING)

      visit schema["base_path"]

      expect(page.status_code).to eq(200)

      assert page.has_css?(".gem-c-intervention")
      assert page.has_link?("Take part in user research", href: survey_url)
    end
  end

  scenario "pages where we don't want to display User Research banner" do
    schema = GovukSchemas::Example.find("mainstream_browse_page", example_name: "level_2_page")
    stub_content_store_has_item(schema["base_path"], schema)
    search_api_has_documents_for_browse_page(schema["content_id"], [schema["base_path"]], page_size: SearchApiSearch::PAGE_SIZE_TO_GET_EVERYTHING)

    visit schema["base_path"]

    expect(page.status_code).to eq(200)
    expect(page).to_not have_selector(".gem-c-intervention")
  end
end
