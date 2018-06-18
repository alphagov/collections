module OrganisationHelpers
  def stub_rummager_latest_content_requests(organisation_slug)
    stub_rummager_latest_documents_request(organisation_slug)
    stub_rummager_latest_announcements_request(organisation_slug)
    stub_rummager_latest_consultations_request(organisation_slug)
    stub_rummager_latest_publications_request(organisation_slug)
    stub_rummager_latest_statistics_request(organisation_slug)
  end

  def stub_rummager_latest_documents_request(organisation_slug)
    stub_request(:get, Plek.new.find("search") + "/search.json?count=3&fields%5B%5D=content_store_document_type&fields%5B%5D=link&fields%5B%5D=public_timestamp&fields%5B%5D=title&filter_organisations=#{organisation_slug}&order=-public_timestamp").
      to_return(body: { results: [
        {
          title: "Rapist has sentence increased after Solicitor General’s referral",
          link: "/government/news/rapist-has-sentence-increased-after-solicitor-generals-referral",
          content_store_document_type: "press release",
          public_timestamp: "2018-06-18T17:39:34.000+01:00"
        }
      ] }.to_json)
  end

  def stub_rummager_latest_announcements_request(organisation_slug)
    stub_request(:get, Plek.new.find("search") + "/search.json?count=2&fields%5B%5D=content_store_document_type&fields%5B%5D=link&fields%5B%5D=public_timestamp&fields%5B%5D=title&filter_email_document_supertype=announcements&filter_organisations=#{organisation_slug}&order=-public_timestamp").
      to_return(body: { results: [] }.to_json)
  end

  def stub_rummager_latest_consultations_request(organisation_slug)
    stub_request(:get, Plek.new.find("search") + "/search.json?count=2&fields%5B%5D=content_store_document_type&fields%5B%5D=link&fields%5B%5D=public_timestamp&fields%5B%5D=title&filter_government_document_supertype=consultations&filter_organisations=#{organisation_slug}&order=-public_timestamp").
      to_return(body: { results: [] }.to_json)
  end

  def stub_rummager_latest_publications_request(organisation_slug)
    stub_request(:get, Plek.new.find("search") + "/search.json?count=2&fields%5B%5D=content_store_document_type&fields%5B%5D=link&fields%5B%5D=public_timestamp&fields%5B%5D=title&filter_email_document_supertype=publications&filter_organisations=#{organisation_slug}&order=-public_timestamp").
      to_return(body: { results: [] }.to_json)
  end

  def stub_rummager_latest_statistics_request(organisation_slug)
    stub_request(:get, Plek.new.find("search") + "/search.json?count=2&fields%5B%5D=content_store_document_type&fields%5B%5D=link&fields%5B%5D=public_timestamp&fields%5B%5D=title&filter_government_document_supertype=statistics&filter_organisations=#{organisation_slug}&order=-public_timestamp").
      to_return(body: { results: [] }.to_json)
  end

  def organisation_with_no_people
    {
      title: "Attorney General's Office",
      details: {
        brand: "attorney-generals-office",
        ordered_ministers: [],
        ordered_board_members: [],
        ordered_military_personnel: [],
        ordered_chief_professional_officers: [],
        ordered_special_representatives: []
      }
    }.with_indifferent_access
  end

  def organisation_with_ministers
    {
      title: "Attorney General's Office",
      base_path: "/government/organisations/attorney-generals-office",
      details: {
        brand: "attorney-generals-office",
        organisation_featuring_priority: "news",
        ordered_ministers: [
          {
            name: "Oliver Dowden CBE MP",
            role: "Parliamentary Secretary (Minister for Implementation)",
            href: "/government/people/oliver-dowden",
            role_href: "/government/ministers/parliamentary-secretary",
            image: {
              url: "/photo/oliver-dowden",
              alt_text: "Oliver Dowden CBE MP"
            }
          },
          {
            name: "Stuart Andrew MP",
            role: "Parliamentary Under Secretary of State",
            href: "/government/people/stuart-andrew",
            role_href: "/government/ministers/parliamentary-under-secretary-of-state--94"
          },
          {
            name_prefix: "The Rt Hon",
            name: "Theresa May MP",
            role: "Prime Minister",
            href: "/government/people/theresa-may",
            role_href: "/government/ministers/prime-minister",
            image: {
              url: "/photo/theresa-may",
              alt_text: "Theresa May MP"
            }
          },
          {
            name_prefix: "The Rt Hon",
            name: "Theresa May MP",
            role: "Minister for the Civil Service",
            href: "/government/people/theresa-may",
            role_href: "/government/ministers/minister-for-the-civil-service",
            image: {
              url: "/photo/theresa-may",
              alt_text: "Theresa May MP"
            }
          }
        ]
      },
      links: {
        ordered_foi_contacts: [
          {
            withdrawn: false,
            details: {
              title: "FOI stuff",
              description: "FOI requests\r\n\r\nare possible",
              post_addresses: [
                {
                  title: "Office of the Secretary of State for Wales",
                  street_address: "Gwydyr House\r\nWhitehall",
                  postal_code: "SW1A 2NP",
                  world_location: "UK"
                },
                {
                  title: "Office of the Secretary of State for Wales Cardiff",
                  street_address: "White House\r\nCardiff",
                  postal_code: "W1 3BZ",
                }
              ],
              email_addresses: [
                {
                  email: "walesofficefoi@walesoffice.gsi.gov.uk"
                },
                {
                  email: "foiwales@walesoffice.gsi.gov.uk"
                }
              ]
            }
          },
          {
            withdrawn: false,
            details: {
              description: "Something here\r\n\r\nSomething there",
              post_addresses: [
                {
                  title: "The Welsh Office",
                  street_address: "Green House\r\nBracknell",
                  postal_code: "B2 3ZZ",
                }
              ],
              email_addresses: [
                {
                  email: "welshofficefoi@walesoffice.gsi.gov.uk"
                }
              ]
            }
          },
          {
            withdrawn: false,
            details: {
              post_addresses: [
                {
                  street_address: "Red House\r\nSlough",
                  postal_code: "S1 9NN",
                }
              ],
              email_addresses: []
            }
          }
        ]
      }
    }.with_indifferent_access
  end

  def organisation_with_board_members
    {
      title: "Attorney General's Office",
      details: {
        brand: "attorney-generals-office",
        ordered_board_members: [
          {
            name: "Sir Jeremy Heywood",
            role: "Cabinet Secretary",
            href: "/government/people/jeremy-heywood",
            image: {
              url: "/photo/jeremy-heywood",
              alt_text: "Sir Jeremy Heywood"
            }
          },
          {
            name: "John Manzoni",
            role: "Chief Executive of the Civil Service ",
            href: "/government/people/john-manzoni",
            image: {
              url: "/photo/john-manzoni",
              alt_text: "John Manzoni"
            }
          },
          {
            name: "John Manzoni",
            role: "Permanent Secretary (Cabinet Office)",
            href: "/government/people/john-manzoni",
            image: {
              url: "/photo/john-manzoni",
              alt_text: "John Manzoni"
            }
          },
        ]
      }
    }.with_indifferent_access
  end

  def organisation_with_policies
    {
      title: "Attorney General's Office",
      base_path: "/government/organisations/attorney-generals-office",
      details: {
        brand: "attorney-generals-office",
        organisation_featuring_priority: "news"
      },
      links: {
        ordered_featured_policies: [
          {
            api_path: "/api/content/government/policies/waste-and-recycling",
            base_path: "/government/policies/waste-and-recycling",
            content_id: "5d5e9324-7631-11e4-a3cb-005056011aef",
            description: "What the government’s doing about waste and recycling.",
            document_type: "policy",
            locale: "en",
            public_updated_at: "2015-05-14T16:39:48Z",
            schema_name: "policy",
            title: "Waste and recycling",
            withdrawn: false,
            links: {},
            api_url: "https://www.gov.uk/api/content/government/policies/waste-and-recycling",
            web_url: "https://www.gov.uk/government/policies/waste-and-recycling"
          },
        ]
      }
    }.with_indifferent_access
  end

  def organisation_with_featured_documents
    {
      title: "Attorney General's Office",
      base_path: "/government/organisations/attorney-generals-office",
      details: {
        brand: "attorney-generals-office",
        organisation_featuring_priority: "news",
        ordered_featured_documents: [
          {
            title: "New head of the Serious Fraud Office announced",
            href: "/government/news/new-head-of-the-serious-fraud-office-announced",
            image: {
              url: "https://assets.publishing.service.gov.uk/jeremy.jpg",
              alt_text: "Attorney General Jeremy Wright QC MP"
            },
            summary: "Lisa Osofsky appointed new Director of the Serious Fraud Office ",
            public_updated_at: "2018-06-04T11:30:03.000+01:00",
            document_type: "Press release"
          },
          {
            title: "New head of a different office announced",
            href: "/government/news/new-head-of-a-different-office-announced",
            image: {
              url: "https://assets.publishing.service.gov.uk/john.jpg",
              alt_text: "John Someone MP"
            },
            summary: "John Someone appointed new Director of the Other Office ",
            public_updated_at: "2017-06-04T11:30:03.000+01:00",
            document_type: "Policy paper"
          }
        ]
      }
    }.with_indifferent_access
  end
end
