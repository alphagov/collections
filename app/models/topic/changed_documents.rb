class Topic::ChangedDocuments
  include Enumerable

  delegate :documents, :total, :start, to: :search_api_search
  delegate :each, to: :documents

  DEFAULT_PAGE_SIZE = 50
  MAX_PAGE_SIZE = 100

  def initialize(topic_content_id, pagination_options = {})
    @topic_content_id = topic_content_id
    @pagination_options = pagination_options
  end

  def page_size
    count = @pagination_options[:count].to_i
    return MAX_PAGE_SIZE if count > MAX_PAGE_SIZE

    count.positive? ? count : DEFAULT_PAGE_SIZE
  end

private

  def start_param
    start = @pagination_options[:start].to_i
    start >= 0 ? start : 0
  end

  def search_api_search
    @search_api_search ||= SearchApiSearch.new(
      start: start_param,
      count: page_size,
      order: "-public_timestamp",
      fields: %w[title link latest_change_note public_timestamp format],
      filter_topic_content_ids: [@topic_content_id],
    )
  end
end
