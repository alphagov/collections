class SearchDocuments
  include SearchApiFields
  DEFAULT_COUNT = 3

  def initialize(slug_array)
    @slug_array = slug_array
  end

  def fetch_related_documents_with_format(filter_format = {})
    search_response = Services.cached_search(default_search_options.merge(filter_format))
    format_results(search_response)
  end

  def filter_field
    Raise NotImplementedError
  end

  def fields
    Raise NotImplementedError
  end

  def order
    Raise NotImplementedError
  end

private

  def default_search_options
    { filter_field.to_sym => @slug_array,
      count: DEFAULT_COUNT,
      order:,
      fields: }
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
