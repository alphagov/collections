require "integration_spec_helper"

RSpec.feature "Mainstream browsing" do
  include SearchApiHelpers

  scenario "that we can handle all examples" do
    # Shuffle the examples to ensure tests don't become order dependent
    schemas = GovukSchemas::Example.find_all("mainstream_browse_page").shuffle

    schemas.each do |content_item|
      stub_content_store_has_item(content_item["base_path"], content_item)

      search_api_has_documents_for_browse_page(
        content_item["content_id"],
        %w[
          employee-tax-codes
          get-paye-forms-p45-p60
          pay-paye-penalty
          pay-paye-tax
          pay-psa
          payroll-annual-reporting
        ],
        page_size: SearchApiSearch::PAGE_SIZE_TO_GET_EVERYTHING,
      )

      visit content_item["base_path"]

      expect(page.status_code).to eq(200)
      expect(page).to have_selector(".gem-c-breadcrumbs")
    end
  end

  scenario "State pension second level browse page displays the Cost of living survey banner" do
    content_item = GovukSchemas::Example.find("mainstream_browse_page", example_name: "curated_level_2_page")
    content_item["base_path"] = "/browse/working/state-pension"

    stub_content_store_has_item("/browse/working/state-pension", content_item)

    search_api_has_documents_for_browse_page(
      content_item["content_id"],
      ["/browse/working/state-pension"],
      page_size: SearchApiSearch::PAGE_SIZE_TO_GET_EVERYTHING,
    )

    visit "/browse/working/state-pension"

    expect(page.status_code).to eq(200)
    expect(page).to have_link "Take part in user research (opens in a new tab)", href: "https://gdsuserresearch.optimalworkshop.com/treejack/ct80d1d6"
  end

  scenario "other browse pages don't show the banner" do
    content_item = GovukSchemas::Example.find("mainstream_browse_page", example_name: "curated_level_2_page")
    content_item["base_path"] = "/browse/benefits/entitlement-with-list"

    stub_content_store_has_item("/browse/benefits/entitlement-with-list", content_item)

    search_api_has_documents_for_browse_page(
      content_item["content_id"],
      ["/browse/benefits/entitlement-with-list"],
      page_size: SearchApiSearch::PAGE_SIZE_TO_GET_EVERYTHING,
    )

    visit "/browse/benefits/entitlement-with-list"

    expect(page.status_code).to eq(200)
    expect(page).not_to have_link "Take part in user research (opens in a new tab)", href: "https://gdsuserresearch.optimalworkshop.com/treejack/ct80d1d6"
  end
end
