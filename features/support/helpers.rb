require "gds_api/test_helpers/content_store"
require "gds_api/test_helpers/search"
require_relative "../../spec/support/search_api_helpers"

module TestHelpers
  include GdsApi::TestHelpers::Search
  include GdsApi::TestHelpers::ContentStore
  include SearchApiHelpers
end

World(TestHelpers)
