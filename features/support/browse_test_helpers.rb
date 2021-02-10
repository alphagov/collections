require "gds_api/test_helpers/content_store"

module BrowseTestHelpers
  include GdsApi::TestHelpers::ContentStore
end

World(BrowseTestHelpers)
