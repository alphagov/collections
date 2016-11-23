require 'gds_api/test_helpers/content_store'
require 'slimmer/test_helpers/govuk_components'

module BrowseTestHelpers
  include GdsApi::TestHelpers::ContentStore
  include Slimmer::TestHelpers::GovukComponents

  def stub_browse_lookups
    stub_shared_component_locales
  end

  def assert_can_see_linked_item(name)
    assert page.has_selector?('a', text: name)
  end
end

World(BrowseTestHelpers)
