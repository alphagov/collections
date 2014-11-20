require 'gds_api/test_helpers/collections_api'

module LatestChangesHelper
  include GdsApi::TestHelpers::CollectionsApi

  def stub_latest_changes_for(base_path)
    collections_api_has_content_for(base_path)
  end

  def visit_latest_changes_for(base_path)
    visit "#{base_path}/latest"
  end

  def assert_page_has_date_ordered_latest_changes
    collections_api_example_documents.each_with_index do |document, index|
      within(".browse-container li:nth-of-type(#{index+1})") do
        assert page.has_selector?("h3 a[href='#{document[:link]}']", text: document[:title])
        assert page.has_content?(document[:latest_change_note]) if document[:latest_change_note]
        assert page.has_selector?("time") if document[:public_updated_at]
      end
    end
  end
end

World(LatestChangesHelper)
