class PopularBrowseSearchDocuments < SearchDocuments
  def fields
    TOPICAL_EVENTS_SEARCH_FIELDS
  end

  def order
    "-popularity"
  end
end
