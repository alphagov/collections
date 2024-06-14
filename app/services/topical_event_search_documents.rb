class TopicalEventSearchDocuments < SearchDocuments
  def filter_field
    "filter_topical_events"
  end

  def fields
    TOPICAL_EVENTS_SEARCH_FIELDS
  end

  def order
    "-public_timestamp"
  end
end
