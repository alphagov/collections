require 'gds_api/rummager'

Collections::Application.config.search_client = GdsApi::Rummager.new(
  ENV["RUMMAGER_HOST"] || Plek.current.find("search")
)
