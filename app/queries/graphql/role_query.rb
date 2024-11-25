class Graphql::RoleQuery
  def initialize(base_path)
    @base_path = base_path
  end

  def query
    <<-QUERY
      {
        edition(basePath: "#{@base_path}") {
          ... on Role {
            basePath
            locale
            title

            details {
              body
              supportsHistoricalAccounts
            }

            links {
              availableTranslations {
                basePath
                locale
              }

              roleAppointments {
                details {
                  current
                  endedOn
                  startedOn
                }

                links {
                  person {
                    basePath
                    title

                    details {
                      body
                    }
                  }
                }
              }

              orderedParentOrganisations {
                basePath
                title
              }
            }
          }
        }
      }
    QUERY
  end
end
