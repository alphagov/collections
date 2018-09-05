module RummagerFields
  TAXON_SEARCH_FIELDS = %w(title
                           link
                           description
                           content_store_document_type
                           public_timestamp
                           content_purpose_supergroup
                           content_purpose_subgroup
                           organisations).freeze

  FEED_SEARCH_FIELDS = %w(title
                          link
                          description
                          display_type
                          public_timestamp).freeze
end
