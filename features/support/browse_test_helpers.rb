require 'gds_api/test_helpers/content_store'

module BrowseTestHelpers
  include GdsApi::TestHelpers::ContentStore

  def assert_can_see_linked_item(name)
    assert page.has_selector?('a', text: name)
  end
end

World(BrowseTestHelpers)
