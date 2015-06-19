
class Subtopic::ChangedDocuments

  DEFAULT_RESULTS_PER_PAGE = 50
  MAX_RESULTS_PER_PAGE = 100

  Document = Struct.new(:title, :base_path, :public_updated_at, :change_note)

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

  private

  def documents
    @_documents ||= search_result["results"].map do |result|
      Document.new(
        result["title"],
        result["link"],
        Time.parse(result["public_timestamp"]),
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
    return MAX_RESULTS_PER_PAGE if count > MAX_RESULTS_PER_PAGE
    count > 0 ? count : DEFAULT_RESULTS_PER_PAGE
  end
end
