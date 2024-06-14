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
      search_api_has_popular_documents_for_level_one_browse(content_item)

      visit content_item["base_path"]

      expect(page.status_code).to eq(200)
      expect(page).to have_selector(".gem-c-breadcrumbs")
    end
  end

  it "renders popular tasks on level 1 browse pages" do
    level_one_browse_slugs = %w[  abroad
                                  benefits
                                  births-deaths-marriages
                                  business
                                  childcare-parenting
                                  citizenship
                                  disabilities
                                  driving
                                  education
                                  employing-people
                                  environment-countryside
                                  housing-local-services
                                  justice
                                  tax
                                  visas-immigration
                                  working]

    level_one_browse_slugs.each do |slug|
      content_item = GovukSchemas::Example.find("mainstream_browse_page", example_name: "top_level_page").tap do |item|
        item["base_path"] = "/browse/#{slug}"
      end
      stub_content_store_has_item(content_item["base_path"], content_item)
      visit content_item["base_path"]
      expect(page).to have_css(".browse__action-links")
      expect(page).to have_content("Popular tasks")
    end
  end

  it "renders the GOV.UK Chat promo" do
    content_item = GovukSchemas::Example.find("mainstream_browse_page", example_name: "top_level_page").tap do |item|
      item["base_path"] = GovukChatPromoHelper::GOVUK_CHAT_PROMO_BASE_PATHS.first
    end

    stub_content_store_has_item(content_item["base_path"], content_item)

    ClimateControl.modify GOVUK_CHAT_PROMO_ENABLED: "true" do
      visit content_item["base_path"]
      expect(page).to have_selector(".gem-c-chat-entry")
    end
  end
end
