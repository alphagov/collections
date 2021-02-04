require "integration_test_helper"

class MainstreamBrowsingTest < ActionDispatch::IntegrationTest
  include SearchApiHelpers

  test "that we can handle all examples" do
    # Shuffle the examples to ensure tests don't become order dependent
    schemas = GovukSchemas::Example.find_all("mainstream_browse_page").shuffle

    # Add all examples to the content store and rummager to allow pages to
    # request their parents and links.
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
    end

    schemas.each do |content_item|
      visit content_item["base_path"]

      assert_equal 200, page.status_code
      assert page.has_css?(".gem-c-breadcrumbs"),
             "Expected page at '#{content_item['base_path']}' to display breadcrumbs, but none found"
    end
  end
end
