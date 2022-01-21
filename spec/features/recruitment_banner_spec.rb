require "integration_spec_helper"

RSpec.feature "Recruitment banner" do
  include SearchApiHelpers

  context "Mainstream browse pages" do
    scenario "browse page is where we want to display recruitment banner" do
      schema = GovukSchemas::Example.find("mainstream_browse_page", example_name: "level_2_page")
      schema["base_path"] = "/browse/visas-immigration/tourist-short-stay-visas"
      stub_content_store_has_item(schema["base_path"], schema)
      search_api_has_documents_for_browse_page(schema["content_id"], %w[/browse/visas-immigration/tourist-short-stay-visas], page_size: SearchApiSearch::PAGE_SIZE_TO_GET_EVERYTHING)

      visit schema["base_path"]

      expect(page.status_code).to eq(200)
      expect(page).to have_selector(".gem-c-intervention")
    end

    scenario "browse page is not where we want to display recruitment banner" do
      schema = GovukSchemas::Example.find("mainstream_browse_page", example_name: "level_2_page")
      stub_content_store_has_item(schema["base_path"], schema)
      search_api_has_documents_for_browse_page(schema["content_id"], [schema["base_path"]], page_size: SearchApiSearch::PAGE_SIZE_TO_GET_EVERYTHING)

      visit schema["base_path"]

      expect(page.status_code).to eq(200)
      expect(page).to_not have_selector(".gem-c-intervention")
    end
  end
end
