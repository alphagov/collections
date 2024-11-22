class Graphql::MinistersIndexQuery
  def initialize(base_path)
    @base_path = base_path
  end

  def query
    <<-QUERY
      {
        edition(basePath: "#{@base_path}") {
          ... on MinistersIndex {
            basePath

            links {
              orderedCabinetMinisters {
                ...basePersonInfo
              }

              orderedAlsoAttendsCabinet {
                ...basePersonInfo
              }

              orderedAssistantWhips {
                ...basePersonInfo
              }

              orderedBaronessesAndLordsInWaitingWhips {
                ...basePersonInfo
              }

              orderedHouseLordsWhips {
                ...basePersonInfo
              }

              orderedHouseOfCommonsWhips {
                ...basePersonInfo
              }

              orderedJuniorLordsOfTheTreasuryWhips {
                ...basePersonInfo
              }

              orderedMinisterialDepartments {
                title
                webUrl

                details {
                  brand

                  logo {
                    crest
                    formattedTitle
                  }
                }

                links {
                  orderedMinisters {
                    ...basePersonInfo
                  }

                  orderedRoles {
                    contentId
                  }
                }
              }
            }
          }
        }
      }

      fragment basePersonInfo on MinistersIndexPerson {
        title
        basePath
        webUrl

        details {
          privyCounsellor

          image {
            url
            altText
          }
        }

        links {
          roleAppointments {
            details {
              current
            }

            links {
              role {
                contentId
                title
                webUrl

                details {
                  rolePaymentType
                  seniority
                  whipOrganisation {
                    label
                    sortOrder
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
