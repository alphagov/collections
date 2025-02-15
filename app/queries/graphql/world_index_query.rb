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
            title

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
