module SearchApiFields
  TAXON_SEARCH_FIELDS = %w[title
                           link
                           description
                           content_store_document_type
                           public_timestamp
                           end_date
                           organisations
                           image_url].freeze

  FEED_SEARCH_FIELDS = %w[title
                          link
                          description
                          display_type
                          public_timestamp].freeze

  TOPICAL_EVENTS_SEARCH_FIELDS = %w[display_type
                                    title
                                    link
                                    public_timestamp
                                    format
                                    content_store_document_type
                                    description
                                    content_id
                                    organisations
                                    document_collections].freeze
end
