class Topic::ChangedDocuments < Topic::ContentTaggedToTopic
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
      )
    end
  end

  def search_params
    super.merge({
      order: "-public_timestamp",
      fields: %w(title link latest_change_note public_timestamp),
    })
  end
end
