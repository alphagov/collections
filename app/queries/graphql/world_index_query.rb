class Graphql::WorldIndexQuery
  def initialize(base_path)
    @base_path = base_path
  end

  def query
    <<-QUERY
      fragment worldLocationInfo on WorldLocation {
        active
        name
        slug
      }

      {
        edition(basePath: "#{@base_path}") {
          ... on WorldIndex {
            title

            details {
              worldLocations {
                ...worldLocationInfo
              }

              internationalDelegations {
                ...worldLocationInfo
              }
            }
          }
        }
      }
    QUERY
  end
end
