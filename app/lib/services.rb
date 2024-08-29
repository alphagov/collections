require "gds_api/content_store"
require "gds_api/search"

module Services
  def self.content_store
    @content_store ||= GdsApi::ContentStore.new(Plek.new.find("content-store"))
  end

  def self.cached_search(params, metric_key: "search.request_time", expiry: 5.minutes)
    Rails.cache.fetch(params, expires_in: expiry) do
      GovukStatsd.time(metric_key) do
        search_api.search(params).to_h
      end
    end
  end

  def self.search_api
    @search_api ||= GdsApi.search
  end
end
