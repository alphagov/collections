class Graphql::RoleQuery
  def initialize(base_path)
    @base_path = base_path
  end

  def query
    <<-QUERY
      {
        edition(base_path: "#{@base_path}") {
          ... on Edition {
            base_path
            locale
            title

            details {
              body
              supports_historical_accounts
            }

            links {
              available_translations {
                base_path
                locale
              }

              role_appointments {
                details {
                  current
                  ended_on
                  started_on
                }

                links {
                  person {
                    base_path
                    title

                    details {
                      body
                    }
                  }
                }
              }

              ordered_parent_organisations {
                base_path
                title
              }
            }
          }
        }
      }
    QUERY
  end
end
