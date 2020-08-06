require_relative "../../test/support/rummager_helpers"

module OrganisationHelpers
  include ::RummagerHelpers

  def stub_rummager_latest_content_requests(organisation_slug)
    stub_latest_content_from_supergroups_request(organisation_slug)
    stub_rummager_latest_documents_request(organisation_slug)
  end

  def stub_latest_content_from_supergroups_request(organisation_slug, empty = false)
    Search::Supergroups::SUPERGROUP_TYPES.each do |group|
      url = build_rummager_query_url(
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

  def build_rummager_query_url(params = {})
    query = Rack::Utils.build_nested_query default_params.merge(params)
    "#{Plek.new.find('search')}/search.json?#{query}"
  end

  def stub_empty_rummager_requests(organisation_slug)
    stub_latest_content_from_supergroups_request(organisation_slug, true)

    url = build_rummager_query_url(
      filter_organisations: organisation_slug,
      reject_content_purpose_supergroup: "other",
      count: 3,
    )

    stub_request(:get, url).to_return(body: build_result_body("other", true).to_json)
  end

  def stub_rummager_latest_documents_request(organisation_slug)
    stub_request(:get, Plek.new.find("search") + "/search.json?count=3&fields%5B%5D=content_store_document_type&fields%5B%5D=link&fields%5B%5D=public_timestamp&fields%5B%5D=title&filter_organisations=#{organisation_slug}&order=-public_timestamp&reject_content_purpose_supergroup=other")
      .to_return(body: { results: [
        {
          title: "Rapist has sentence increased after Solicitor General’s referral",
          link: "/government/news/rapist-has-sentence-increased-after-solicitor-generals-referral",
          content_store_document_type: "press release",
          public_timestamp: "2018-06-18T17:39:34.000+01:00",
        },
      ] }.to_json)
  end

  def stub_rummager_latest_content_with_acronym(organisation_slug)
    stub_request(:get, Plek.new.find("search") + "/search.json?count=3&fields%5B%5D=content_store_document_type&fields%5B%5D=link&fields%5B%5D=public_timestamp&fields%5B%5D=title&filter_organisations=#{organisation_slug}&order=-public_timestamp&reject_content_purpose_supergroup=other")
      .to_return(body: { results: [
        {
          title: "Rapist has sentence increased after Solicitor General’s referral",
          link: "/government/news/rapist-has-sentence-increased-after-solicitor-generals-referral",
          content_store_document_type: "dfid_research_output",
          public_timestamp: "2018-06-18T17:39:34.000+01:00",
        },
      ] }.to_json)
  end

  def current_role_appointment(title:, base_path: nil, payment_type: nil, document_type: nil, content_id: nil)
    {
      details: {
        current: true,
      },
      links: {
        role: [
          {
            content_id: content_id,
            title: title,
            base_path: base_path,
            document_type: document_type,
            details: { role_payment_type: payment_type },
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
              url: "https://assets.publishing.service.gov.uk/john.jpg",
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

  def latest_documents_with_acronyms
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
              alt_text: "Attorney General Jeremy Wright QC MP",
            },
            summary: "Lisa Osofsky appointed new Director of the Serious Fraud Office ",
            public_updated_at: "2018-06-04T11:30:03.000+01:00",
            document_type: "Dfid_research_output",
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
                image: {
                  url: "https://assets.publishing.service.gov.uk/government/uploads/3-1.jpg",
                  alt_text: "Image 3-1",
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

  def when_i_visit_a_courts_page
    content = GovukSchemas::Example.find("organisation", example_name: "court")
    content["details"]["body"] = "We review decisions."

    setup_and_visit_page(content)
  end

  def when_i_visit_an_hmcts_tribunal_page
    content = GovukSchemas::Example.find("organisation", example_name: "tribunal")
    content["details"]["body"] = "We handle appeals."

    setup_and_visit_page(content)
  end

  def setup_and_visit_page(content)
    stub_content_store_has_item(content["base_path"], content)
    @title = content["title"]
    @what_we_do = content.dig("details", "body")

    visit content["base_path"]
  end

  def and_the_breadcrumbs_collapse_on_mobile
    assert page.has_css?(".gem-c-breadcrumbs--collapse-on-mobile")
  end

  def i_see_the_courts_breadcrumb
    assert page.has_css?(".gem-c-breadcrumbs", text: "Courts and Tribunals")
  end

  def the_correct_title
    assert page.has_title?("#{@title} - GOV.UK")
    assert page.has_css?(".gem-c-organisation-logo", text: @title)

    # Does not have the No. 10 banner
    assert_not page.has_css?(".organisation__no10-banner")
  end

  def the_courts_title
    assert page.has_title?("#{@title} - GOV.UK")
    assert page.has_css?(".gem-c-title__text", text: @title)
  end

  def and_featured_links
    assert page.has_css?(".app-c-topic-list")
  end

  def and_the_what_we_do_section
    assert page.has_css?("section#what-we-do", text: @what_we_do)
  end

  def and_contacts
    assert page.has_css?("section#org-contacts")
  end

  def and_there_is_schema_org_information
    schema_sections = page.find_all("script[type='application/ld+json']", visible: false)
    schemas = schema_sections.map { |section| JSON.parse(section.text(:all)) }

    org_schema = schemas.detect { |schema| schema["@type"] == "GovernmentOrganization" }
    assert_equal org_schema["name"], @title
  end

  def but_no_documents
    assert_not page.has_css?("section#latest-documents")
    assert_not page.has_css?(".gem-c-heading", text: "Documents")
    assert_not page.has_css?(".gem-c-heading", text: "Our announcements")
    assert_not page.has_css?(".gem-c-heading", text: "Our consultations")
    assert_not page.has_css?(".gem-c-heading", text: "Our publications")
    assert_not page.has_css?(".gem-c-heading", text: "Our statistics")
  end

  def or_foi_section
    assert_not page.has_content?(/Make an FOI request/i)
    assert_not page.has_content?(/Freedom of Information (FOI) Act/i)
  end

  def or_corporate_information
    assert_not page.has_css?("div#corporate-info")
  end
end
