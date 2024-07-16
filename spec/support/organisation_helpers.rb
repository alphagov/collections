require_relative "../../spec/support/search_api_helpers"

module OrganisationHelpers
  include ::SearchApiHelpers

  def stub_search_api_latest_content_requests(organisation_slug)
    stub_latest_content_from_supergroups_request(organisation_slug)
    stub_search_api_latest_documents_request(organisation_slug)
  end

  def stub_latest_content_from_supergroups_request(organisation_slug, empty: false)
    Search::Supergroups::SUPERGROUP_TYPES.each do |group|
      url = build_search_api_query_url(
        {
          filter_organisations: organisation_slug,
          filter_content_purpose_supergroup: group,
          order: Search::Supergroup::DEFAULT_SORT_ORDER,
        }.merge(Search::Supergroups::SUPERGROUP_ADDITIONAL_SEARCH_PARAMS.fetch(group, {})),
      )

      stub_request(:get, url).to_return(body: build_result_body(group, empty).to_json)
    end
  end

  def build_result_body(group, empty, result_count = 2)
    return { results: [] } if empty || group == "services"

    {
      results: generate_search_results(result_count, group),
    }
  end

  def default_params
    {
      count: 2,
      'fields[]': %w[
        content_store_document_type
        link
        public_timestamp
        title
      ],
      order: "-public_timestamp",
    }
  end

  def build_search_api_query_url(params = {})
    query = Rack::Utils.build_nested_query default_params.merge(params)
    "#{Plek.new.find('search-api')}/search.json?#{query}"
  end

  def stub_empty_search_api_requests(organisation_slug)
    stub_latest_content_from_supergroups_request(organisation_slug, empty: true)

    url = build_search_api_query_url(
      filter_organisations: organisation_slug,
      count: 4,
    )

    stub_request(:get, url).to_return(body: build_result_body("other", true).to_json)
  end

  def stub_latest_news_for_organisation(organisation_slug)
    stub_request(:get, Plek.new.find("search-api") + "/search.json?count=5&filter_content_purpose_supergroup%5B%5D=news_and_communications&filter_organisations%5B%5D=#{organisation_slug}&order=-public_timestamp")
      .to_return(body: { results: latest_news_search_response }.to_json)

    stub_content_store_has_item(latest_news_search_response.first[:link], latest_news_content_item_with_image.to_json)
  end

  def stub_search_api_latest_documents_request(organisation_slug)
    stub_request(:get, Plek.new.find("search-api") + "/search.json?count=4&fields%5B%5D=content_store_document_type&fields%5B%5D=link&fields%5B%5D=public_timestamp&fields%5B%5D=title&filter_organisations=#{organisation_slug}&order=-public_timestamp")
      .to_return(body: { results: [search_response] }.to_json)
  end

  def stub_search_api_latest_content_with_acronym(organisation_slug)
    stub_request(:get, Plek.new.find("search-api") + "/search.json?count=4&fields%5B%5D=content_store_document_type&fields%5B%5D=link&fields%5B%5D=public_timestamp&fields%5B%5D=title&filter_organisations=#{organisation_slug}&order=-public_timestamp")
      .to_return(body: { results: [search_response] }.to_json)
  end

  def stub_search_api_latest_documents_request_includes_org_page(organisation_slug)
    stub_request(:get, Plek.new.find("search-api") + "/search.json?count=4&fields%5B%5D=content_store_document_type&fields%5B%5D=link&fields%5B%5D=public_timestamp&fields%5B%5D=title&filter_organisations=#{organisation_slug}&order=-public_timestamp")
      .to_return(body: { results: [search_response, org_page_search_response(organisation_slug)] }.to_json)
  end

  def search_response
    {
      title: "Attorney General launches recruitment campaign for new Chief Inspector",
      link: "/government/news/attorney-general-launches-recruitment-campaign-for-new-chief-inspector",
      content_store_document_type: "press release",
      public_timestamp: "2020-07-26T23:15:09.000+00:00",
    }
  end

  def latest_news_content_item_with_image
    {
      details: { image: "https://www.example.com/latest-news-item-with-image.png" },
    }
  end

  def latest_news_search_response
    [
      {
        title: "Latest news item with image",
        link: "/government/news/latest-news-item-with-image",
        content_store_document_type: "press release",
        public_timestamp: "2020-07-26T23:15:29.000+00:00",
      },
      {
        title: "Latest news item (link only)",
        link: "/government/news/latest-news-item-link-only",
        content_store_document_type: "press release",
        public_timestamp: "2020-07-26T23:15:09.000+00:00",
      },
    ]
  end

  def org_page_search_response(organisation_slug)
    {
      title: "Org page for this organisation",
      link: "/government/organisations/#{organisation_slug}",
      content_store_document_type: "organisation",
      public_timestamp: "2020-07-26T23:15:09.000+00:00",
    }
  end

  def current_role_appointment(title:, base_path: nil, payment_type: nil, document_type: nil, content_id: nil, seniority: nil)
    {
      details: {
        current: true,
      },
      links: {
        role: [
          {
            content_id:,
            title:,
            base_path:,
            document_type:,
            details: { role_payment_type: payment_type, seniority: },
          }.compact,
        ],
      },
    }
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
        ordered_special_representatives: [],
      },
      links: {},
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
      },
      links: {
        ordered_roles: [
          { content_id: "264a1f0e-6e0a-479b-83d4-2660afe36339" },
          { content_id: "61a62a60-df26-4454-81da-0594f0d74d76" },
          { content_id: "849f0fdc-6393-49fa-9661-9afdfb40615c" },
          { content_id: "3f4bbf6c-741e-4207-9135-63d1c8f39c28" },
          { content_id: "ac6e554d-f7d2-4c15-8a0c-91eedc1e3c31" },
          { content_id: "6d8eb1a6-41f2-4381-9c06-de697c0ff2c5" },
        ],
        ordered_ministers: [
          {
            title: "Oliver Dowden CBE MP",
            locale: "en",
            base_path: "/government/people/oliver-dowden",
            details: {
              image: {
                url: "/photo/oliver-dowden",
                alt_text: "Oliver Dowden CBE MP",
              },
            },
            links: {
              role_appointments: [
                current_role_appointment(
                  content_id: "264a1f0e-6e0a-479b-83d4-2660afe36339",
                  title: "Parliamentary Secretary (Minister for Implementation)",
                  base_path: "/government/ministers/parliamentary-secretary",
                  document_type: "ministerial_role",
                ),
              ],
            },
          },
          {
            title: "Stuart Andrew MP",
            locale: "en",
            base_path: "/government/people/stuart-andrew",
            details: {},
            links: {
              role_appointments: [
                current_role_appointment(
                  content_id: "61a62a60-df26-4454-81da-0594f0d74d76",
                  title: "Parliamentary Under Secretary of State",
                  base_path: "/government/ministers/parliamentary-under-secretary-of-state--94",
                  document_type: "ministerial_role",
                ),
              ],
            },
          },
          {
            title: "The Rt Hon Theresa May MP",
            locale: "en",
            base_path: "/government/people/theresa-may",
            details: {
              image: {
                url: "/photo/theresa-may",
                alt_text: "Theresa May MP",
              },
            },
            links: {
              role_appointments: [
                current_role_appointment(
                  content_id: "849f0fdc-6393-49fa-9661-9afdfb40615c",
                  title: "Prime Minister",
                  base_path: "/government/ministers/prime-minister",
                  document_type: "ministerial_role",
                ),
                current_role_appointment(
                  content_id: "3f4bbf6c-741e-4207-9135-63d1c8f39c28",
                  title: "Minister for the Civil Service",
                  base_path: "/government/ministers/minister-for-the-civil-service",
                  document_type: "ministerial_role",
                ),
              ],
            },
          },
          {
            title: "Victoria Atkins MP",
            locale: "en",
            base_path: "/government/people/victoria-atkins",
            details: {
              image: {
                url: "/photo/victoria-atkins",
                alt_text: "Victoria Atkins MP",
              },
            },
            links: {
              role_appointments: [
                current_role_appointment(
                  content_id: "6d8eb1a6-41f2-4381-9c06-de697c0ff2c5",
                  title: "Minister for Afghan Resettlement",
                  base_path: "/government/ministers/minister-for-afghan-resettlement",
                  document_type: "ministerial_role",
                  seniority: 100,
                ),
                current_role_appointment(
                  content_id: "ac6e554d-f7d2-4c15-8a0c-91eedc1e3c31",
                  title: "Minister of State",
                  base_path: "/government/ministers/minister-of-state--61",
                  document_type: "ministerial_role",
                  seniority: 99,
                ),
              ],
            },
          },
        ],
      },
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
      },
      links: {
        ordered_roles: [
          { content_id: "264a1f0e-6e0a-479b-83d4-2660afe36339" },
          { content_id: "61a62a60-df26-4454-81da-0594f0d74d76" },
          { content_id: "849f0fdc-6393-49fa-9661-9afdfb40615c" },
        ],
        ordered_board_members: [
          {
            title: "Sir Jeremy Heywood",
            locale: "en",
            base_path: "/government/people/jeremy-heywood",
            details: {
              image: {
                url: "/photo/jeremy-heywood",
                alt_text: "Sir Jeremy Heywood",
              },
            },
            links: {
              role_appointments: [
                current_role_appointment(
                  content_id: "264a1f0e-6e0a-479b-83d4-2660afe36339",
                  title: "Cabinet Secretary",
                  document_type: "board_member_role",
                ),
              ],
            },
          },
          {
            title: "John Manzoni",
            locale: "en",
            base_path: "/government/people/john-manzoni",
            details: {
              image: {
                url: "/photo/john-manzoni",
                alt_text: "John Manzoni",
              },
            },
            links: {
              role_appointments: [
                current_role_appointment(
                  content_id: "61a62a60-df26-4454-81da-0594f0d74d76",
                  title: "Chief Executive of the Civil Service",
                  document_type: "board_member_role",
                ),
                current_role_appointment(
                  content_id: "849f0fdc-6393-49fa-9661-9afdfb40615c",
                  title: "Permanent Secretary (Cabinet Office)",
                  document_type: "board_member_role",
                ),
              ],
            },
          },
        ],
      },
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
      },
      links: {
        ordered_roles: [
          { content_id: "264a1f0e-6e0a-479b-83d4-2660afe36339" },
          { content_id: "61a62a60-df26-4454-81da-0594f0d74d76" },
        ],
        ordered_board_members: [
          {
            title: "Sir Jeremy Heywood",
            locale: "en",
            base_path: "/government/people/jeremy-heywood",
            details: {
              image: {
                url: "/photo/jeremy-heywood",
                alt_text: "Sir Jeremy Heywood",
              },
            },
            links: {
              role_appointments: [
                current_role_appointment(
                  content_id: "264a1f0e-6e0a-479b-83d4-2660afe36339",
                  title: "Cabinet Secretary",
                  document_type: "board_member_role",
                  payment_type: "Unpaid",
                ),
              ],
            },
          },
          {
            title: "John Manzoni",
            locale: "en",
            base_path: "/government/people/john-manzoni",
            details: {
              image: {
                url: "/photo/john-manzoni",
                alt_text: "John Manzoni",
              },
            },
            links: {
              role_appointments: [
                current_role_appointment(
                  content_id: "61a62a60-df26-4454-81da-0594f0d74d76",
                  title: "Chief Executive of the Civil Service",
                  document_type: "board_member_role",
                ),
              ],
            },
          },
        ],
      },
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
      },
    }.with_indifferent_access
  end

  def organisation_with_featured_documents_and_is_no_10
    {
      title: "Number 10",
      base_path: "/government/organisations/prime-ministers-office-10-downing-street",
      details: {
        organisation_govuk_status: {
          status: "live",
        },
        brand: "prime-ministers-office-10-downing-street",
        organisation_featuring_priority: "news",
        ordered_featured_documents: [
          {
            title: "New head of the Serious Fraud Office announced",
            href: "/government/news/new-head-of-the-serious-fraud-office-announced",
            image: {
              url: "https://assets.publishing.service.gov.uk/media/original_asset_manager_id/jeremy.jpg",
              medium_resolution_url: "https://assets.publishing.service.gov.uk/media/s465_asset_manager_id/s465_jeremy.jpg",
              high_resolution_url: "https://assets.publishing.service.gov.uk/media/s712_asset_manager_id/s712_jeremy.jpg",
              alt_text: "Attorney General Jeremy Wright QC MP",
            },
            summary: "Lisa Osofsky appointed new Director of the Serious Fraud Office ",
            public_updated_at: "2018-06-04T11:30:03.000+01:00",
            document_type: "Press release",
          },
          {
            title: "New head of a different office announced",
            href: "/government/news/new-head-of-a-different-office-announced",
            image: {
              url: "https://assets.publishing.service.gov.uk/media/original_asset_manager_id/john.jpg",
              medium_resolution_url: "https://assets.publishing.service.gov.uk/media/s465_asset_manager_id/s465_john.jpg",
              high_resolution_url: "https://assets.publishing.service.gov.uk/media/s712_asset_manager_id/s712_john.jpg",
              alt_text: "John Someone MP",
            },
            summary: "John Someone appointed new Director of the Other Office ",
            public_updated_at: "2017-06-04T11:30:03.000+01:00",
            document_type: "Policy paper",
          },
        ],
      },
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
              url: "https://assets.publishing.service.gov.uk/media/original_asset_manager_id/jeremy.jpg",
              medium_resolution_url: "https://assets.publishing.service.gov.uk/media/s465_asset_manager_id/s465_jeremy.jpg",
              high_resolution_url: "https://assets.publishing.service.gov.uk/media/s712_asset_manager_id/s712_jeremy.jpg",
              alt_text: "Attorney General Jeremy Wright QC MP",
            },
            summary: "Lisa Osofsky appointed new Director of the Serious Fraud Office ",
            public_updated_at: "2018-06-04T11:30:03.000+01:00",
            document_type: "Press release",
          },
          {
            title: "New head of a different office announced",
            href: "/government/news/new-head-of-a-different-office-announced",
            image: {
              url: "https://assets.publishing.service.gov.uk/media/original_asset_manager_id/john.jpg",
              medium_resolution_url: "https://assets.publishing.service.gov.uk/media/s465_asset_manager_id/s465_john.jpg",
              high_resolution_url: "https://assets.publishing.service.gov.uk/media/s712_asset_manager_id/s712_john.jpg",
              alt_text: "John Someone MP",
            },
            summary: "John Someone appointed new Director of the Other Office ",
            public_updated_at: "2017-06-04T11:30:03.000+01:00",
            document_type: "Policy paper",
          },
        ],
      },
    }.with_indifferent_access
  end

  def organisation_with_featured_documents_and_missing_urls
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
              url: "https://assets.publishing.service.gov.uk/media/original_asset_manager_id/jeremy.jpg",
              medium_resolution_url: "https://assets.publishing.service.gov.uk/media/s465_asset_manager_id/s465_jeremy.jpg",
              alt_text: "Attorney General Jeremy Wright QC MP",
            },
            summary: "Lisa Osofsky appointed new Director of the Serious Fraud Office ",
            public_updated_at: "2018-06-04T11:30:03.000+01:00",
            document_type: "Press release",
          },
          {
            title: "New head of a different office announced",
            href: "/government/news/new-head-of-a-different-office-announced",
            image: {
              url: "https://assets.publishing.service.gov.uk/media/original_asset_manager_id/john.jpg",
              high_resolution_url: "https://assets.publishing.service.gov.uk/media/s712_asset_manager_id/s712_john.jpg",
              alt_text: "John Someone MP",
            },
            summary: "John Someone appointed new Director of the Other Office ",
            public_updated_at: "2017-06-04T11:30:03.000+01:00",
            document_type: "Policy paper",
          },
        ],
      },
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
            details: { organisation_govuk_status: { status: "live" } },
          },
          {
            base_path: "/government/organisations/another-rural-development-programme-for-england-network",
            title: "Another Rural Development Programme for England Network",
            details: { organisation_govuk_status: { status: "live" } },
          },
          {
            base_path: "/government/organisations/yet-another-rural-development-programme-for-england-network",
            title: "Yet another Rural Development Programme for England Network",
            details: { organisation_govuk_status: { status: "closed" } },
          },
        ],
      },
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
        },
      },
      links: {
        ordered_foi_contacts: [
          {
            locale: "en",
            withdrawn: false,
            details: {
              title: "FOI stuff",
              description: "FOI requests\r\n\r\nare possible",
              contact_form_links: [
                {
                  title: "title",
                  link: "/to/some/foi/stuff",
                  description: "Click me",
                },
              ],
              post_addresses: [
                {
                  title: "Office of the Secretary of State for Wales",
                  street_address: "Gwydyr House\r\nWhitehall",
                  postal_code: "SW1A 2NP",
                  world_location: "UK",
                },
                {
                  title: "Office of the Secretary of State for Wales Cardiff",
                  street_address: "White House\r\nCardiff",
                  postal_code: "W1 3BZ",
                },
              ],
              email_addresses: [
                {
                  email: "walesofficefoi@walesoffice.gsi.gov.uk",
                },
                {
                  email: "foiwales@walesoffice.gsi.gov.uk",
                },
              ],
            },
          },
          {
            locale: "en",
            withdrawn: false,
            details: {
              description: "Something here\r\n\r\nSomething there",
              contact_form_links: [
                {
                  title: "",
                  link: "/foi/stuff",
                  description: "",
                },
              ],
              post_addresses: [
                {
                  title: "The Welsh Office",
                  street_address: "Green House\r\nBracknell",
                  postal_code: "B2 3ZZ",
                },
              ],
              email_addresses: [
                {
                  email: "welshofficefoi@walesoffice.gsi.gov.uk",
                },
              ],
            },
          },
          {
            locale: "en",
            withdrawn: false,
            details: {
              description: "",
              contact_form_links: [],
              post_addresses: [],
              email_addresses: [],
            },
          },
        ],
      },
    }.with_indifferent_access
  end

  def organisation_with_contact_details
    {
      title: "Attorney General's Office",
      base_path: "/government/organisations/attorney-generals-office",
      details: {
        brand: "attorney-generals-office",
      },
      links: {
        ordered_contacts: [
          {
            locale: "en",
            title: "Department for International Trade",
            details: {
              title: "Department for International Trade",
              post_addresses: [{
                title: "",
                street_address: "King Charles Street\r\nWhitehall",
                postal_code: "SW1A 2AH",
                world_location: "United Kingdom",
                locality: "London",
              }],
              email_addresses: [{
                title: "",
                email: "enquiries@trade.gov.uk",
              }],
              phone_numbers: [{
                title: "Custom Telephone",
                number: "+44 (0) 20 7215 5000",
              }],
              contact_form_links: [{
                title: "Department for Trade",
                link: "/contact",
              }],
            },
          },
        ],
      },
    }.with_indifferent_access
  end

  def organisation_with_empty_contact_details
    {
      title: "Attorney General's Office",
      base_path: "/government/organisations/attorney-generals-office",
      details: {
        brand: "attorney-generals-office",
      },
      links: {
        ordered_contacts: [
          {
            locale: "en",
            title: "Department for International Trade",
            details: {
              title: "Department for International Trade",
              post_addresses: [{
                title: "",
                street_address: " ",
                postal_code: " ",
                world_location: "",
                locality: "",
              }],
            },
          },
        ],
      },
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
            href: "/corporate-info",
          },
          {
            title: "Jobs",
            href: "/jobs",
          },
          {
            title: "Working for Attorney General's Office",
            href: "/government/attorney-general's-office/recruitment",
          },
          {
            title: "Procurement at Attorney General's Office",
            href: "/government/attorney-general's-office/procurement",
          },
        ],
        secondary_corporate_information_pages: "Read more about our pages",
      },
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
                  alt_text: "Image 1-1",
                },
                links: [
                  {
                    title: "Single departmental plans",
                    href: "https://www.gov.uk/government/collections/1-1",
                  },
                  {
                    title: "Prime Minister's and Cabinet Office ministers' transparency publications",
                    href: "https://www.gov.uk/government/collections/ministers-transparency-publications/1-1",
                  },
                ],
              },
            ],
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
                  alt_text: "Image 2-1",
                },
                links: [
                  {
                    title: "Single departmental plans",
                    href: "https://www.gov.uk/government/collections/2-1",
                  },
                  {
                    title: "Prime Minister's and Cabinet Office ministers' transparency publications",
                    href: "https://www.gov.uk/government/collections/ministers-transparency-publications/2-1",
                  },
                ],
              },
              {
                title: "",
                href: "https://www.gov.uk/government/policies/2-2",
                summary: "Story 2-2",
                image: {
                  url: "https://assets.publishing.service.gov.uk/government/uploads/2-2.jpg",
                  alt_text: "Image 2-2",
                },
                links: [
                  {
                    title: "Single departmental plans",
                    href: "https://www.gov.uk/government/collections/2-2",
                  },
                  {
                    title: "Prime Minister's and Cabinet Office ministers' transparency publications",
                    href: "https://www.gov.uk/government/collections/ministers-transparency-publications/2-2",
                  },
                ],
              },
            ],
          },
          {
            title: "Three features",
            items: [
              {
                title: "",
                href: "https://www.gov.uk/government/policies/3-1",
                summary: "Story 3-1\r\n\r\nAnd a new line",
                youtube_video: {
                  id: "fFmDQn9Lbl4",
                  alt_text: "YouTube video alt text.",
                },
                links: [
                  {
                    title: "Single departmental plans",
                    href: "https://www.gov.uk/government/collections/3-1",
                  },
                  {
                    title: "Prime Minister's and Cabinet Office ministers' transparency publications",
                    href: "https://www.gov.uk/government/collections/ministers-transparency-publications/3-1",
                  },
                ],
              },
              {
                title: "",
                href: "https://www.gov.uk/government/policies/3-3",
                summary: "Story 3-2",
                image: {
                  url: "https://assets.publishing.service.gov.uk/government/uploads/3-2.jpg",
                  alt_text: "Image 3-2",
                },
                links: [
                  {
                    title: "Single departmental plans",
                    href: "https://www.gov.uk/government/collections/3-2",
                  },
                  {
                    title: "Prime Minister's and Cabinet Office ministers' transparency publications",
                    href: "https://www.gov.uk/government/collections/ministers-transparency-publications/3-2",
                  },
                ],
              },
              {
                title: "An unexpected title",
                href: "https://www.gov.uk/government/policies/3-3",
                summary: "Story 3-3",
                image: {
                  url: "https://assets.publishing.service.gov.uk/government/uploads/3-3.jpg",
                  alt_text: "Image 3-3",
                },

                links: [
                  {
                    title: "Single departmental plans",
                    href: "https://www.gov.uk/government/collections/3-3",
                  },
                  {
                    title: "Prime Minister's and Cabinet Office ministers' transparency publications",
                    href: "https://www.gov.uk/government/collections/ministers-transparency-publications/3-3",
                  },
                ],
              },
            ],
          },
        ],
      },
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
          },
        ],
      },
    }.with_indifferent_access
  end

  def organisation_content_schema_example(name)
    GovukSchemas::Example.find("organisation", example_name: name)
  end

  def stub_content_and_search(content_item)
    slug = content_item["base_path"].split("/").last
    stub_content_store_has_item(content_item["base_path"], content_item)
    stub_search_api_latest_content_requests(slug)
  end

  def test_ga4_image_cards(selector, section_heading = nil)
    ga4_selector = "#{selector}[data-module='ga4-link-tracker'][data-ga4-track-links-only]"
    expect(page).to have_css(ga4_selector)

    ga4_link_data = JSON.parse(page.first(ga4_selector)["data-ga4-link"])
    expect(ga4_link_data["event_name"]).to eq "navigation"
    expect(ga4_link_data["type"]).to eq "image card"
    section_heading ||= page.first("#{selector} h2").text
    expect(ga4_link_data["section"]).to eq section_heading
  end

  def test_ga4_see_all_link(section_heading = nil, link_text = "See all latest documents")
    see_all_link = page.find("#latest-documents a", text: link_text)
    expect(see_all_link["data-module"]).to eq "ga4-link-tracker"
    ga4_link_data = JSON.parse(see_all_link["data-ga4-link"])
    expect(ga4_link_data["event_name"]).to eq "navigation"
    expect(ga4_link_data["type"]).to eq "see all"
    section_heading ||= page.first("#latest-documents h2").text
    expect(ga4_link_data["section"]).to eq section_heading
  end

  def test_ga4_get_emails_link(section_heading = nil)
    email_div = page.find("#latest-documents ul.gem-c-document-list ~ div")
    expect(email_div["data-module"]).to eq "ga4-link-tracker"
    expect(email_div["data-ga4-track-links-only"]).to eq ""
    ga4_link_data = JSON.parse(email_div["data-ga4-link"])
    expect(ga4_link_data["event_name"]).to eq "navigation"
    expect(ga4_link_data["type"]).to eq "subscribe"
    expect(ga4_link_data["index_link"]).to eq 1
    expect(ga4_link_data["index_total"]).to eq 1
    section_heading ||= page.first("#latest-documents h2").text
    expect(ga4_link_data["section"]).to eq section_heading
  end

  def test_ga4_email_links(selector, section_heading = nil)
    section_heading ||= page.first("#{selector} h2").text
    links = page.all("#{selector} p[data-ga4-link]")
    links.each do |link|
      expect(link["data-module"]).to eq "ga4-link-tracker"
      expect(link["data-ga4-do-not-redact"]).to eq ""
      expect(link["data-ga4-track-links-only"]).to eq ""
      ga4_link_data = JSON.parse(link["data-ga4-link"])
      expect(ga4_link_data["event_name"]).to eq "navigation"
      expect(ga4_link_data["type"]).to eq "email"
      expect(ga4_link_data["section"]).to eq section_heading
    end
  end

  def test_ga4_organisation_supergroup_links(section_headings)
    supergroups = page.all("[data-ga4-section-documents]")
    supergroups.each_with_index do |supergroup, index|
      see_all_link = supergroup.find("a[data-ga4-link]")
      expect(see_all_link["data-module"]).to eq "ga4-link-tracker"
      ga4_link_data = JSON.parse(see_all_link["data-ga4-link"])
      expect(ga4_link_data["event_name"]).to eq "navigation"
      expect(ga4_link_data["type"]).to eq "see all"
      expect(ga4_link_data["section"]).to eq section_headings[index]
    end
  end
end
