require 'integration_test_helper'

class MainstreamBrowsingTest < ActionDispatch::IntegrationTest
  include RummagerHelpers

  test "that we can handle all examples" do
    # Add all examples to the content store and rummager to allow pages to
    # request their parents and links.
    content_schema_examples_for(:mainstream_browse_page).each do |content_item|
      content_store_has_item(content_item['base_path'], content_item)
    end

    content_schema_examples_for(:mainstream_browse_page).each do |content_item|
      visit content_item['base_path']

      assert_equal 200, page.status_code
      assert page.has_selector?(shared_component_selector('breadcrumbs')),
        "Expected page at '#{content_item['base_path']}' to display breadcrumbs, but none found"
    end
  end
end
