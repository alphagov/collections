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
                analytics_identifier
                base_path
                title
              }

              organisations {
                analytics_identifier
              }
            }
          }
        }
      }
    QUERY
  end
end
