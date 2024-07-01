class TopicalEventSearchDocuments < SearchDocuments
  def fields
    TOPICAL_EVENTS_SEARCH_FIELDS
  end

  def order
    "-public_timestamp"
  end
end
