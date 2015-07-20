
class Topic::ChangedDocuments

  DEFAULT_PAGE_SIZE = 50
  MAX_PAGE_SIZE = 100

  def initialize(subtopic_slug, pagination_options = {})
    @subtopic_slug = subtopic_slug
    @pagination_options = pagination_options
  end

  def each
    documents.each do |d|
      yield d
    end
  end
  include Enumerable

  def total
    search_result["total"]
  end

  def start
    search_result["start"]
  end

  def page_size
    count_param
  end

  private

  def documents
    @_documents ||= search_result["results"].map do |result|
      timestamp = result["public_timestamp"].present? ? Time.parse(result["public_timestamp"]) : nil
      Topic::Document.new(
        result["title"],
        result["link"],
        timestamp,
        result["latest_change_note"],
      )
    end
  end

  def search_result
    @_search_result ||= Rails.application.config.search_client.unified_search(search_params)
  end

  def search_params
    {
      start: start_param,
      count: count_param,
      filter_specialist_sectors: [@subtopic_slug],
      order: "-public_timestamp",
      fields: %w(title link latest_change_note public_timestamp),
    }
  end

  def start_param
    start = @pagination_options[:start].to_i
    start >= 0 ? start : 0
  end

  def count_param
    count = @pagination_options[:count].to_i
    return MAX_PAGE_SIZE if count > MAX_PAGE_SIZE
    count > 0 ? count : DEFAULT_PAGE_SIZE
  end
end
