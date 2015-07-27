require 'integration_test_helper'

class MainstreamBrowsingTest < ActionDispatch::IntegrationTest
  include RummagerHelpers

  test "that we can handle all examples" do
    # Add all examples to the content store and content api to allow pages to
    # request their parents and links.
    content_schema_examples_for(:mainstream_browse_page).each do |content_item|
      content_store_has_item(content_item['base_path'], content_item)

      slug = content_item['base_path'].gsub('/browse/', '')

      rummager_has_documents_for_browse_page(
        slug,
        [
          "employee-tax-codes",
          "get-paye-forms-p45-p60",
          "pay-paye-penalty",
          "pay-paye-tax",
          "pay-psa",
          "payroll-annual-reporting",
        ],
        page_size: RummagerSearch::PAGE_SIZE_TO_GET_EVERYTHING
      )
    end

    content_schema_examples_for(:mainstream_browse_page).each do |content_item|
      get content_item['base_path']
      assert_response 200
    end
  end
end
