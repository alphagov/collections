class FeedContent
  attr_reader :search_query

  def initialize(search_query)
    @search_query = search_query
  end

  def results
    search_response["results"]
  end

private

  def search_response
    params = search_query.merge(
      start: 0,
      count: 20,
      fields: SearchApiFields::FEED_SEARCH_FIELDS,
      reject_content_purpose_supergroup: "other",
      order: "-public_timestamp",
    )

    @search_response ||= Services.cached_search(params, metric_key: "feeds.search.request_time")
  end
end
