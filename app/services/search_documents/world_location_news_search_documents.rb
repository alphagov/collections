class SearchDocuments
  class WorldLocationNewsSearchDocuments < SearchDocuments
    def filter_field
      "filter_world_locations"
    end

    def fields
      WORLD_LOCATION_NEWS_SEARCH_FIELDS
    end

    def order
      "-public_timestamp"
    end
  end
end
