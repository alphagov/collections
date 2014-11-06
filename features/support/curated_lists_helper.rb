require 'gds_api/test_helpers/collections_api'

module CuratedListsHelper
  include GdsApi::TestHelpers::CollectionsApi

  def stub_curated_lists_for(base_path)
    collections_api_has_content_for(base_path)
  end

  def assert_page_has_curated_lists
    expected_group_titles_from_stubbed_collections_api = ['Oil rigs', 'Piping']

    expected_group_titles_from_stubbed_collections_api.each do |group_title|
      assert page.has_selector?("h1", text: "#{group_title}")
    end
  end
end

World(CuratedListsHelper)
