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

      if content_item["links"]["second_level_browse_pages"].present?
        content_ids = content_item["links"]["second_level_browse_pages"].map { |link| link["content_id"] }
        search_api_has_popular_documents_for_level_one_browse(content_ids)
      end

      visit content_item["base_path"]

      expect(page.status_code).to eq(200)
      expect(page).to have_selector(".gem-c-breadcrumbs")
    end
  end

  describe "popular tasks" do
    it "renders on level one browse pages" do
      content_item = GovukSchemas::Example.find("mainstream_browse_page", example_name: "top_level_page")
      stub_content_store_has_item(content_item["base_path"], content_item)
      content_ids = content_item["links"]["second_level_browse_pages"].map { |link| link["content_id"] }
      search_api_has_popular_documents_for_level_one_browse(content_ids)

      visit content_item["base_path"]
      expect(page).to have_css(".browse__action-links")
      expect(page).to have_content("Most viewed")
    end
  end

  it "does not render on the root browse page" do
    content_item = GovukSchemas::Example.find("mainstream_browse_page", example_name: "root_page")
    stub_content_store_has_item(content_item["base_path"], content_item)

    visit content_item["base_path"]
    expect(page).not_to have_css(".browse__action-links")
    expect(page).not_to have_content("Most viewed")
  end

  it "does not render on level two browse pages" do
    content_item = GovukSchemas::Example.find("mainstream_browse_page", example_name: "level_2_page")
    stub_content_store_has_item(content_item["base_path"], content_item)
    search_api_has_documents_for_browse_page(content_item["content_id"], %w[a-slug], page_size: 1000)

    visit content_item["base_path"]
    expect(page).not_to have_css(".browse__action-links")
    expect(page).not_to have_content("Most viewed")
  end

  it "renders the GOV.UK Chat promo" do
    content_item = GovukSchemas::Example.find("mainstream_browse_page", example_name: "top_level_page").tap do |item|
      item["base_path"] = "/browse/business"
    end

    stub_content_store_has_item(content_item["base_path"], content_item)
    content_ids = content_item["links"]["second_level_browse_pages"].map { |link| link["content_id"] }
    search_api_has_popular_documents_for_level_one_browse(content_ids)

    ClimateControl.modify GOVUK_CHAT_PROMO_ENABLED: "true" do
      visit content_item["base_path"]
      expect(page).to have_selector(".gem-c-chat-entry")
    end
  end
end
