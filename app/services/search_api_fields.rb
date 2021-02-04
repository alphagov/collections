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
end
