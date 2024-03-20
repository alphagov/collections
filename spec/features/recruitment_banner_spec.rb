require "integration_spec_helper"

RSpec.feature "Research panel banner" do
  include SearchApiHelpers
  include OrganisationHelpers
  include RecruitmentBannerHelper

  scenario "browse pages where we want to display Brand User Research banner" do
    base_path = "/browse/benefits"
    schema = GovukSchemas::Example.find("mainstream_browse_page", example_name: "level_2_page")
    schema["base_path"] = base_path
    stub_content_store_has_item(schema["base_path"], schema)
    search_api_has_documents_for_browse_page(schema["content_id"], [base_path], page_size: SearchApiSearch::PAGE_SIZE_TO_GET_EVERYTHING)

    visit schema["base_path"]

    expect(page.status_code).to eq(200)
    expect(page).to have_selector(".gem-c-intervention")
  end

  scenario "organisation pages where we want to display Brand User Research banner" do
    base_path = "/government/organisations/department-for-work-pensions"
    schema = GovukSchemas::Example.find("organisation", example_name: "tribunal")
    schema["base_path"] = base_path
    stub_content_and_search(schema)

    visit schema["base_path"]

    expect(page.status_code).to eq(200)
    expect(page).to have_selector(".gem-c-intervention")
  end

  scenario "pages where we don't want to display Brand User Research banner" do
    schema = GovukSchemas::Example.find("mainstream_browse_page", example_name: "level_2_page")
    stub_content_store_has_item(schema["base_path"], schema)
    search_api_has_documents_for_browse_page(schema["content_id"], [schema["base_path"]], page_size: SearchApiSearch::PAGE_SIZE_TO_GET_EVERYTHING)

    visit schema["base_path"]

    expect(page.status_code).to eq(200)
    expect(page).to_not have_selector(".gem-c-intervention")
  end
end
