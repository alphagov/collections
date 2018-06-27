module OrganisationHelpers
  def stub_rummager_latest_content_requests(organisation_slug)
    stub_rummager_latest_documents_request(organisation_slug)
    stub_rummager_latest_announcements_request(organisation_slug)
    stub_rummager_latest_consultations_request(organisation_slug)
    stub_rummager_latest_publications_request(organisation_slug)
    stub_rummager_latest_statistics_request(organisation_slug)
  end

  def stub_empty_rummager_requests(organisation_slug)
    stub_request(:get, Plek.new.find("search") + "/search.json?count=3&fields%5B%5D=content_store_document_type&fields%5B%5D=link&fields%5B%5D=public_timestamp&fields%5B%5D=title&filter_organisations=#{organisation_slug}&order=-public_timestamp&reject_email_document_supertype=other").
    to_return(body: { results: [] }.to_json)

    stub_request(:get, Plek.new.find("search") + "/search.json?count=2&fields%5B%5D=content_store_document_type&fields%5B%5D=link&fields%5B%5D=public_timestamp&fields%5B%5D=title&filter_email_document_supertype=announcements&filter_organisations=#{organisation_slug}&order=-public_timestamp").
      to_return(body: { results: [] }.to_json)

    stub_request(:get, Plek.new.find("search") + "/search.json?count=2&fields%5B%5D=content_store_document_type&fields%5B%5D=link&fields%5B%5D=public_timestamp&fields%5B%5D=title&filter_government_document_supertype=consultations&filter_organisations=#{organisation_slug}&order=-public_timestamp").
      to_return(body: { results: [] }.to_json)

    stub_request(:get, Plek.new.find("search") + "/search.json?count=2&fields%5B%5D=content_store_document_type&fields%5B%5D=link&fields%5B%5D=public_timestamp&fields%5B%5D=title&filter_email_document_supertype=publications&filter_organisations=#{organisation_slug}&order=-public_timestamp&reject_government_document_supertype%5B%5D=consultations&reject_government_document_supertype%5B%5D=statistics").
      to_return(body: { results: [] }.to_json)

    stub_request(:get, Plek.new.find("search") + "/search.json?count=2&fields%5B%5D=content_store_document_type&fields%5B%5D=link&fields%5B%5D=public_timestamp&fields%5B%5D=title&filter_government_document_supertype=statistics&filter_organisations=#{organisation_slug}&order=-public_timestamp").
      to_return(body: { results: [] }.to_json)
  end

  def stub_rummager_latest_documents_request(organisation_slug)
    stub_request(:get, Plek.new.find("search") + "/search.json?count=3&fields%5B%5D=content_store_document_type&fields%5B%5D=link&fields%5B%5D=public_timestamp&fields%5B%5D=title&filter_organisations=#{organisation_slug}&order=-public_timestamp&reject_email_document_supertype=other").
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
      to_return(body: { results: [
        {
          title: "First events announced for National Democracy Week",
          link: "/government/news/first-events-announced-for-national-democracy-week",
          content_store_document_type: "press release",
          public_timestamp: "2018-06-13T17:39:34.000+01:00"
        }
      ] }.to_json)
  end

  def stub_rummager_latest_consultations_request(organisation_slug)
    stub_request(:get, Plek.new.find("search") + "/search.json?count=2&fields%5B%5D=content_store_document_type&fields%5B%5D=link&fields%5B%5D=public_timestamp&fields%5B%5D=title&filter_government_document_supertype=consultations&filter_organisations=#{organisation_slug}&order=-public_timestamp").
      to_return(body: { results: [
        {
          title: "Consultation on revised Code of Data Matching Practice",
          link: "/government/consultations/consultation-on-revised-code-of-data-matching-practice",
          content_store_document_type: "closed_consultation",
          public_timestamp: "2018-04-27T17:39:34.000+01:00"
        }
      ] }.to_json)
  end

  def stub_rummager_latest_publications_request(organisation_slug)
    stub_request(:get, Plek.new.find("search") + "/search.json?count=2&fields%5B%5D=content_store_document_type&fields%5B%5D=link&fields%5B%5D=public_timestamp&fields%5B%5D=title&filter_email_document_supertype=publications&filter_organisations=#{organisation_slug}&order=-public_timestamp&reject_government_document_supertype%5B%5D=consultations&reject_government_document_supertype%5B%5D=statistics").
      to_return(body: { results: [
        {
          title: "National Democracy Week: partner pack",
          link: "/government/publications/national-democracy-week-partner-pack",
          content_store_document_type: "guidance",
          public_timestamp: "2018-06-18T17:39:34.000+01:00"
        }
      ] }.to_json)
  end

  def stub_rummager_latest_statistics_request(organisation_slug)
    stub_request(:get, Plek.new.find("search") + "/search.json?count=2&fields%5B%5D=content_store_document_type&fields%5B%5D=link&fields%5B%5D=public_timestamp&fields%5B%5D=title&filter_government_document_supertype=statistics&filter_organisations=#{organisation_slug}&order=-public_timestamp").
      to_return(body: { results: [] }.to_json)
  end

  def organisation_with_no_people
    {
      title: "Attorney General's Office",
      base_path: "/government/organisations/attorney-generals-office",
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
        organisation_govuk_status: {
          status: "live",
        },
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
      }
    }.with_indifferent_access
  end

  def organisation_with_board_members
    {
      title: "Attorney General's Office",
      base_path: "/government/organisations/attorney-generals-office",
      details: {
        brand: "attorney-generals-office",
        organisation_govuk_status: {
          status: "live",
        },
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

  def organisation_with_non_important_board_members
    {
      title: "Attorney General's Office",
      base_path: "/government/organisations/attorney-generals-office",
      details: {
        brand: "attorney-generals-office",
        organisation_govuk_status: {
          status: "live",
        },
        important_board_members: 1,
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
        ]
      }
    }.with_indifferent_access
  end

  def organisation_with_policies
    {
      title: "Attorney General's Office",
      base_path: "/government/organisations/attorney-generals-office",
      details: {
        organisation_govuk_status: {
          status: "live",
        },
        brand: "attorney-generals-office",
        organisation_featuring_priority: "news"
      },
      links: {
        ordered_featured_policies: [
          {
            base_path: "/government/policies/waste-and-recycling",
            document_type: "policy",
            title: "Waste and recycling"
          },
        ]
      }
    }.with_indifferent_access
  end

  def organisation_with_multiple_policies
    {
      title: "Attorney General's Office",
      base_path: "/government/organisations/attorney-generals-office",
      details: {
        organisation_govuk_status: {
          status: "live",
        },
        brand: "attorney-generals-office",
        organisation_featuring_priority: "news"
      },
      links: {
        ordered_featured_policies: [
          {
            base_path: "/government/policies/policy-1",
            document_type: "policy",
            title: "Policy 1"
          },
          {
            base_path: "/government/policies/policy-2",
            document_type: "policy",
            title: "Policy 2"
          },
          {
            base_path: "/government/policies/policy-3",
            document_type: "policy",
            title: "Policy 3"
          },
          {
            base_path: "/government/policies/policy-4",
            document_type: "policy",
            title: "Policy 4"
          },
          {
            base_path: "/government/policies/policy-5",
            document_type: "policy",
            title: "Policy 5"
          },
          {
            base_path: "/government/policies/policy-6",
            document_type: "policy",
            title: "Policy 6"
          },
        ]
      }
    }.with_indifferent_access
  end

  def organisation_with_no_documents
    {
      title: "Org with No Docs",
      base_path: "/government/organisations/org-with-no-docs",
      details: {
        organisation_govuk_status: {
          status: "live",
        },
        brand: "org-with-no-docs",
        organisation_featuring_priority: "news",
      }
    }.with_indifferent_access
  end

  def organisation_with_featured_documents
    {
      title: "Attorney General's Office",
      base_path: "/government/organisations/attorney-generals-office",
      details: {
        organisation_govuk_status: {
          status: "live",
        },
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

  def organisation_with_high_profile_groups
    {
      title: "Department for Environment, Food & Rural Affairs",
      base_path: "/government/organisations/department-for-environment-food-rural-affairs",
      details: {
        organisation_govuk_status: {
          status: "live",
        },
        acronym: "Defra",
        brand: "department-for-environment-food-rural-affairs",
        organisation_featuring_priority: "news",
      },
      links: {
        ordered_high_profile_groups: [
          {
            base_path: "/government/organisations/rural-development-programme-for-england-network",
            title: "Rural Development Programme for England Network",
          },
          {
            base_path: "/government/organisations/rural-development-programme-for-england-network-2",
            title: "Rural Development Programme for England Network 2",
          }
        ]
      }
    }.with_indifferent_access
  end

  def organisation_with_foi
    {
      title: "Attorney General's Office",
      base_path: "/government/organisations/attorney-generals-office",
      details: {
        brand: "attorney-generals-office",
        organisation_featuring_priority: "news",
        organisation_govuk_status: {
          status: "live",
        }
      },
      links: {
        ordered_foi_contacts: [
          {
            withdrawn: false,
            details: {
              title: "FOI stuff",
              description: "FOI requests\r\n\r\nare possible",
              contact_form_links: [
                {
                  title: "title",
                  link: "/to/some/foi/stuff",
                  description: "Click me"
                }
              ],
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
              contact_form_links: [
                {
                  title: "",
                  link: "/foi/stuff",
                  description: ""
                }
              ],
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
              description: "",
              contact_form_links: [],
              post_addresses: [],
              email_addresses: []
            }
          }
        ]
      }
    }.with_indifferent_access
  end

  def organisation_with_contact_details
    {
      title: "Attorney General's Office",
      base_path: "/government/organisations/attorney-generals-office",
      details: {
        brand: "attorney-generals-office"
      },
      links: {
        ordered_contacts: [
          {
            title: "Department for International Trade",
            details: {
              title: "Department for International Trade",
              post_addresses: [{
                title: "",
                street_address: "King Charles Street\r\nWhitehall",
                postal_code: "SW1A 2AH",
                world_location: "United Kingdom",
                locality: "London"
              }],
              email_addresses: [{
                title: "",
                email: "enquiries@trade.gov.uk"
              }],
              phone_numbers: [{
                title: "Custom Telephone",
                number: "+44 (0) 20 7215 5000"
              }],
              contact_form_links: [{
                title: "Department for Trade",
                link: "/contact"
              }]
            }
          }
        ]
      }
    }.with_indifferent_access
  end

  def organisation_with_corporate_information
    {
      title: "Attorney General's Office",
      base_path: "/government/organisations/attorney-generals-office",
      details: {
        brand: "attorney-generals-office",
        ordered_corporate_information_pages: [
          {
            title: "Corporate Information page",
            href: "/corporate-info"
          },
          {
            title: "Jobs",
            href: "/jobs"
          },
          {
            title: "Working for Attorney General's Office",
            href: "/government/attorney-general's-office/recruitment"
          },
          {
            title: "Procurement at Attorney General's Office",
            href: "/government/attorney-general's-office/procurement"
          },
        ],
        secondary_corporate_information_pages: "Read more about our pages"
      }
    }.with_indifferent_access
  end

  def organisation_with_promotional_features
    {
      title: "Prime Minister's Office, 10 Downing Street",
      base_path: "/government/organisations/attorney-generals-office",
      details: {
        ordered_promotional_features: [
          {
            title: "One feature",
            items: [
              {
                title: "",
                href: "https://www.gov.uk/government/policies/1-1",
                summary: "Story 1-1",
                image: {
                  url: "https://assets.publishing.service.gov.uk/government/uploads/1-1.jpg",
                  alt_text: "Image 1-1"
                },
                links: [
                  {
                    title: "Single departmental plans",
                    href: "https://www.gov.uk/government/collections/1-1"
                  },
                  {
                    title: "Prime Minister's and Cabinet Office ministers' transparency publications",
                    href: "https://www.gov.uk/government/collections/ministers-transparency-publications/1-1"
                  }
                ]
              }
            ]
          },
          {
            title: "Two features",
            items: [
              {
                title: "",
                href: "https://www.gov.uk/government/policies/2-1",
                summary: "Story 2-1",
                image: {
                  url: "https://assets.publishing.service.gov.uk/government/uploads/2-1.jpg",
                  alt_text: "Image 2-1"
                },
                links: [
                  {
                    title: "Single departmental plans",
                    href: "https://www.gov.uk/government/collections/2-1"
                  },
                  {
                    title: "Prime Minister's and Cabinet Office ministers' transparency publications",
                    href: "https://www.gov.uk/government/collections/ministers-transparency-publications/2-1"
                  }
                ]
              },
              {
                title: "",
                href: "https://www.gov.uk/government/policies/2-2",
                summary: "Story 2-2",
                image: {
                  url: "https://assets.publishing.service.gov.uk/government/uploads/2-2.jpg",
                  alt_text: "Image 2-2"
                },
                links: [
                  {
                    title: "Single departmental plans",
                    href: "https://www.gov.uk/government/collections/2-2"
                  },
                  {
                    title: "Prime Minister's and Cabinet Office ministers' transparency publications",
                    href: "https://www.gov.uk/government/collections/ministers-transparency-publications/2-2"
                  }
                ]
              }
            ]
          },
          {
            title: "Three features",
            items: [
              {
                title: "",
                href: "https://www.gov.uk/government/policies/3-1",
                summary: "Story 3-1\r\n\r\nAnd a new line",
                image: {
                  url: "https://assets.publishing.service.gov.uk/government/uploads/3-1.jpg",
                  alt_text: "Image 3-1"
                },
                links: [
                  {
                    title: "Single departmental plans",
                    href: "https://www.gov.uk/government/collections/3-1"
                  },
                  {
                    title: "Prime Minister's and Cabinet Office ministers' transparency publications",
                    href: "https://www.gov.uk/government/collections/ministers-transparency-publications/3-1"
                  }
                ]
              },
              {
                title: "",
                href: "https://www.gov.uk/government/policies/3-3",
                summary: "Story 3-2",
                image: {
                  url: "https://assets.publishing.service.gov.uk/government/uploads/3-2.jpg",
                  alt_text: "Image 3-2"
                },
                links: [
                  {
                    title: "Single departmental plans",
                    href: "https://www.gov.uk/government/collections/3-2"
                  },
                  {
                    title: "Prime Minister's and Cabinet Office ministers' transparency publications",
                    href: "https://www.gov.uk/government/collections/ministers-transparency-publications/3-2"
                  }
                ]
              },
              {
                title: "An unexpected title",
                href: "https://www.gov.uk/government/policies/3-3",
                summary: "Story 3-3",
                image: {
                  url: "https://assets.publishing.service.gov.uk/government/uploads/3-3.jpg",
                  alt_text: "Image 3-3"
                },
                links: [
                  {
                    title: "Single departmental plans",
                    href: "https://www.gov.uk/government/collections/3-3"
                  },
                  {
                    title: "Prime Minister's and Cabinet Office ministers' transparency publications",
                    href: "https://www.gov.uk/government/collections/ministers-transparency-publications/3-3"
                  }
                ]
              }
            ]
          }
        ]
      }
    }.with_indifferent_access
  end

  def organisation_with_translations
    {
      title: "Office of the Secretary of State for Wales",
      base_path: "/government/organisations/office-of-the-secretary-of-state-for-wales",
      details: {
        brand: "attorney-generals-office",
      },
      links: {
        available_translations: [
          {
            base_path: "/government/organisations/office-of-the-secretary-of-state-for-wales.cy",
            locale: "cy",
          },
          {
            base_path: "/government/organisations/office-of-the-secretary-of-state-for-wales",
            locale: "en",
          }
        ]
      }
    }.with_indifferent_access
  end
end
