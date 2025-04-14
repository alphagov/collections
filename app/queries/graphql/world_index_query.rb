class Graphql::WorldIndexQuery
  def initialize(base_path)
    @base_path = base_path
  end

  def query
    <<-QUERY
      fragment worldLocationInfo on Edition {
        active
        name
        slug
      }

      {
        edition(base_path: "#{@base_path}") {
          ... on Edition {
            content_id
            document_type
            first_published_at
            locale
            public_updated_at
            publishing_app
            rendering_app
            schema_name
            title
            updated_at

            details {
              world_locations {
                ...worldLocationInfo
              }

              international_delegations {
                ...worldLocationInfo
              }
            }
          }
        }
      }
    QUERY
  end
end
