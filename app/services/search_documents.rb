class SearchDocuments
  include SearchApiFields
  DEFAULT_COUNT = 3

  def initialize(slug, filter_field)
    @slug = slug
    @filter_field = filter_field
  end

  def fetch_related_documents_with_format(filter_format = {})
    search_response = Services.search_api.search(default_search_options.merge(filter_format))
    format_results(search_response)
  end

private

  def default_search_options
    { @filter_field.to_sym => [@slug],
      count: DEFAULT_COUNT,
      order: "-public_timestamp",
      fields: TOPICAL_EVENTS_SEARCH_FIELDS }
  end

  def display_type(document)
    key = document.fetch("display_type", nil) || document.fetch("content_store_document_type", "")
    key.humanize
  end

  def format_results(search_response)
    search_response["results"].map do |document|
      {
        link: {
          text: document["title"],
          path: document["link"],
        },
        metadata: {
          public_updated_at: Time.zone.parse(document["public_timestamp"]),
          document_type: display_type(document),
        },
      }
    end
  end
end
