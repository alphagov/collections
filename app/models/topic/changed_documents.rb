class Topic::ChangedDocuments < Topic::ContentTaggedToTopic
  DEFAULT_PAGE_SIZE = 50
  MAX_PAGE_SIZE = 100

  def initialize(subtopic_slug, pagination_options = {})
    super(subtopic_slug, pagination_options)
  end

  def documents
    @_documents ||= search_result["results"].map do |result|
      timestamp = result["public_timestamp"].present? ? Time.parse(result["public_timestamp"]) : nil
      Topic::Document.new(
        result["title"],
        result["link"],
        timestamp,
        result["latest_change_note"],
        result["format"]
      )
    end
  end

  def page_size
    count = @pagination_options[:count].to_i
    return MAX_PAGE_SIZE if count > MAX_PAGE_SIZE
    count > 0 ? count : DEFAULT_PAGE_SIZE
  end

  def search_params
    super.merge({
      start: start_param,
      count: page_size,
      order: "-public_timestamp",
      fields: %w(title link latest_change_note public_timestamp format),
    })
  end

  def start_param
    start = @pagination_options[:start].to_i
    start >= 0 ? start : 0
  end
end
