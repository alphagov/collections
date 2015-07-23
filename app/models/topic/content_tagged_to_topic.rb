class Topic::ContentTaggedToTopic
  PAGE_SIZE_TO_GET_EVERYTHING = 10_000

  include Enumerable

  def initialize(topic_slug, pagination_options = {})
    @topic_slug = topic_slug
    @pagination_options = pagination_options
  end

  def documents
    @_documents ||= search_result["results"].map do |result|
      timestamp = result["public_timestamp"].present? ? Time.parse(result["public_timestamp"]) : nil
      Topic::Document.new(
        result["title"],
        result["link"],
        timestamp,
        nil,
        result["format"],
      )
    end
  end

  def each
    documents.each do |d|
      yield d
    end
  end

  def total
    search_result["total"]
  end

  def start
    search_result["start"]
  end

  private

  def search_result
    @_search_result ||= Rails.application.config.search_client.unified_search(search_params)
  end

  def search_params
    {
      start: 0,
      count: PAGE_SIZE_TO_GET_EVERYTHING,
      filter_specialist_sectors: [@topic_slug],
      fields: %w(title link public_timestamp format),
    }
  end
end
