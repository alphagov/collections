class BrowseSearchDocuments < SearchDocuments
  def filter_field
    "filter_any_mainstream_browse_pages"
  end

  def fields
    POPULAR_BROWSE_SEARCH_FIELDS
  end

  def order
    "-popularity"
  end

  def fetch_related_documents_with_format(filter_format = {})
    search_response = Services.cached_search(default_search_options.merge(filter_format))
    search_response["results"].map do |result|
      {
        title: result["title"],
        link: result["link"],
      }
    end
  end
end
