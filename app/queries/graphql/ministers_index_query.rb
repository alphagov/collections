class Graphql::MinistersIndexQuery
  def initialize(base_path)
    @base_path = base_path
  end

  def query
    <<-QUERY
      {
        edition(base_path: "#{@base_path}") {
          ... on MinistersIndex {
            base_path
            content_id
            document_type
            first_published_at
            locale
            public_updated_at
            publishing_app
            rendering_app
            schema_name
            updated_at

            details {
              body
              reshuffle
            }

            links {
              ordered_cabinet_ministers {
                ...basePersonInfo
              }

              ordered_also_attends_cabinet {
                ...basePersonInfo
              }

              ordered_assistant_whips {
                ...basePersonInfo
              }

              ordered_baronesses_and_lords_in_waiting_whips {
                ...basePersonInfo
              }

              ordered_house_lords_whips {
                ...basePersonInfo
              }

              ordered_house_of_commons_whips {
                ...basePersonInfo
              }

              ordered_junior_lords_of_the_treasury_whips {
                ...basePersonInfo
              }

              ordered_ministerial_departments {
                title
                web_url

                details {
                  brand

                  logo {
                    crest
                    formatted_title
                  }
                }

                links {
                  ordered_ministers {
                    ...basePersonInfo
                  }

                  ordered_roles {
                    content_id
                  }
                }
              }
            }
          }
        }
      }

      fragment basePersonInfo on MinistersIndexPerson {
        title
        base_path
        web_url

        details {
          privy_counsellor

          image {
            url
            alt_text
          }
        }

        links {
          role_appointments {
            details {
              current
            }

            links {
              role {
                content_id
                title
                web_url

                details {
                  role_payment_type
                  seniority
                  whip_organisation {
                    label
                    sort_order
                  }
                }
              }
            }
          }
        }
      }
    QUERY
  end
end
