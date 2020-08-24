require "integration_test_helper"

class OrganisationTest < ActionDispatch::IntegrationTest
  include OrganisationHelpers

  before do
    org_example = GovukSchemas::Example.find("organisation", example_name: "organisation")

    @content_item_no10 = {
      title: "Prime Minister's Office, 10 Downing Street",
      description: "10 Downing Street is the official residence of the British Prime Minister.",
      base_path: "/government/organisations/prime-ministers-office-10-downing-street",
      details: {
        body: "10 Downing Street is the official residence and the office of the British Prime Minister.",
        brand: "cabinet-office",
        logo: {
          formatted_title: "Prime Minister&#39;s Office, 10 Downing Street",
          crest: "eo",
        },
        organisation_govuk_status: {
          status: "live",
        },
        organisation_type: "executive_office",
        organisation_featuring_priority: "news",
        ordered_featured_documents: [
          {
            title: "Government calls on technology firms to help tackle the UK’s biggest challenges",
            href: "/government/news/government-calls-on-technology-firms-to-help-tackle-the-uks-biggest-challenges",
            image: {
              url: "https://assets.publishing.service.gov.uk/government/uploads/system/uploads/feature/image/62609/Dowden.jpg",
              alt_text: "Cabinet Office Minister Oliver Dowden",
            },
            summary: "The government is launching competitions for tech firms to develop solutions to tackle the major social challenges of our modern age.",
            public_updated_at: "2018-05-10T00:00:01.000+01:00",
            document_type: "Press release",
          },
        ],
        social_media_links: [
          {
            service_type: "twitter",
            title: "Twitter - @10DowningStreet",
            href: "https://twitter.com/@10DowningStreet",
          },
          {
            service_type: "facebook",
            title: "Facebook",
            href: "https://www.facebook.com/10downingstreet",
          },
        ],
        ordered_promotional_features: [
          {
            title: "Transparency",
            items: [
              {
                title: "",
                href: "https://www.gov.uk/government/policies?keywords=&topics%5B%5D=government-efficiency-transparency-and-accountability&departments%5B%5D=all",
                summary: "Greater transparency across government is at the heart of our commitment to let you hold politicians and public bodies to account. ",
                image: {
                  url: "https://assets.publishing.service.gov.uk/government/uploads/system/uploads/promotional_feature_item/image/1/Transparency.jpg",
                  alt_text: "Magnifying glass studying a graph",
                },
                links: [
                  {
                    title: "Single departmental plans",
                    href: "https://www.gov.uk/government/collections/a-country-that-works-for-everyone-the-governments-plan",
                  },
                  {
                    title: "Prime Minister's and Cabinet Office ministers' transparency publications",
                    href: "https://www.gov.uk/government/collections/ministers-transparency-publications",
                  },
                  {
                    title: "Government transparency data",
                    href: "https://www.gov.uk/government/publications?keywords=&publication_filter_option=transparency-data&topics%5B%5D=all&departments%5B%5D=all&world_locations%5B%5D=all&direction=before&date=2013-05-01",
                  },
                ],
              },
            ],
          },
        ],
      },
      links: {
        available_translations: [],
        ordered_high_profile_groups: [
          {
            base_path: "/government/organisations/attorney-generals-office-1",
            title: "High Profile Group 1",
            details: { organisation_govuk_status: { status: "live" } },
          },
          {
            base_path: "/government/organisations/attorney-generals-office-2",
            title: "High Profile Group 2",
            details: { organisation_govuk_status: { status: "live" } },
          },
        ],
        ordered_roles: [
          { content_id: "61a62a60-df26-4454-81da-0594f0d74d76" },
        ],
        ordered_ministers: [
          {
            content_id: "ec7cb2ba-3c02-48c5-a918-1f4a211499ae",
            title: "The Rt Hon Theresa May MP",
            base_path: "/government/people/theresa-may",
            details: {
              image: {
                url: "https://assets.publishing.service.gov.uk/government/uploads/system/uploads/person/image/6/PM_portrait_960x640.jpg",
                alt_text: "Theresa May MP",
              },
            },
            links: {
              role_appointments: [
                current_role_appointment(
                  content_id: "61a62a60-df26-4454-81da-0594f0d74d76",
                  title: "Prime Minister",
                  base_path: "/government/ministers/prime-minister",
                  document_type: "ministerial_role",
                ),
              ],
            },
          },
        ],
      },
    }

    @content_item_attorney_general = {
      title: "Attorney General's Office",
      base_path: "/government/organisations/attorney-generals-office",
      details: {
        acronym: "AGO",
        body: "The Attorney General's Office (AGO) provides legal advice and support to the Attorney General and the Solicitor General (the Law Officers) who give legal advice to government. The AGO helps the Law Officers perform other duties in the public interest, such as looking at sentences which may be too low.\r\n\r\n",
        brand: "attorney-generals-office",
        logo: {
          formatted_title: "Attorney <br/>General&#39;s <br/>Office",
          crest: "single-identity",
        },
        organisation_govuk_status: {
          status: "live",
        },
        organisation_type: "ministerial_department",
        organisation_featuring_priority: "news",
        ordered_corporate_information_pages: [
          {
            title: "Complaints procedure",
            href: "/complaints-procedure",
          },
          {
            title: "Jobs",
            href: "https://www.civilservicejobs.service.gov.uk/csr",
          },
        ],
        ordered_featured_links: [
          {
            title: "Attorney General's guidance to the legal profession",
            href: "https://www.gov.uk/browse/justice/courts-sentencing-tribunals/attorney-general-guidance-to-the-legal-profession",
          },
        ],
        ordered_featured_documents: [
          {
            title: "New head of the Serious Fraud Office announced",
            href: "/government/news/new-head-of-the-serious-fraud-office-announced",
            image: {
              url: "https://assets.publishing.service.gov.uk/government/uploads/system/uploads/feature/image/63252/Jeremy_Wright_FOR_WEBSITE.jpg",
              alt_text: "Attorney General Jeremy Wright QC MP",
            },
            summary: "Lisa Osofsky appointed new Director of the Serious Fraud Office ",
            public_updated_at: "2018-06-04T11:30:03.000+01:00",
            document_type: "Press release",
          },
        ],
        social_media_links: [
          {
            service_type: "twitter",
            title: "Twitter - @attorneygeneral",
            href: "https://twitter.com/@attorneygeneral",
          },
        ],
        ordered_promotional_features: [
          {
            title: "Transparency",
            items: [
              {
                title: "",
                href: "https://www.gov.uk/government/policies?keywords=&topics%5B%5D=government-efficiency-transparency-and-accountability&departments%5B%5D=all",
                summary: "Greater transparency across government is at the heart of our commitment to let you hold politicians and public bodies to account. ",
                image: {
                  url: "https://assets.publishing.service.gov.uk/government/uploads/system/uploads/promotional_feature_item/image/1/Transparency.jpg",
                  alt_text: "Magnifying glass studying a graph",
                },
                links: [
                  {
                    title: "Single departmental plans",
                    href: "https://www.gov.uk/government/collections/a-country-that-works-for-everyone-the-governments-plan",
                  },
                  {
                    title: "Prime Minister's and Cabinet Office ministers' transparency publications",
                    href: "https://www.gov.uk/government/collections/ministers-transparency-publications",
                  },
                  {
                    title: "Government transparency data",
                    href: "https://www.gov.uk/government/publications?keywords=&publication_filter_option=transparency-data&topics%5B%5D=all&departments%5B%5D=all&world_locations%5B%5D=all&direction=before&date=2013-05-01",
                  },
                ],
              },
            ],
          },
        ],
      },
      links: {
        ordered_roles: [
          { content_id: "264a1f0e-6e0a-479b-83d4-2660afe36339" },
          { content_id: "61a62a60-df26-4454-81da-0594f0d74d76" },
          { content_id: "849f0fdc-6393-49fa-9661-9afdfb40615c" },
        ],
        available_translations: [],
        ordered_board_members: [
          {
            content_id: "ec7cb2ba-3c02-48c5-a918-1f4a211499ae",
            title: "Sir Jeremy Heywood",
            base_path: "/government/people/jeremy-heywood",
            details: {},
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
        ],
        ordered_ministers: [
          {
            content_id: "ec7cb2ba-3c02-48c5-a918-1f4a211499ae",
            title: "The Rt Hon Theresa May MP",
            base_path: "/government/people/theresa-may",
            details: {
              image: {
                url: "https://assets.publishing.service.gov.uk/government/uploads/system/uploads/person/image/6/PM_portrait_960x640.jpg",
                alt_text: "Theresa May MP",
              },
            },
            links: {
              role_appointments: [
                current_role_appointment(
                  content_id: "61a62a60-df26-4454-81da-0594f0d74d76",
                  title: "Prime Minister",
                  base_path: "/government/ministers/prime-minister",
                  document_type: "ministerial_role",
                ),
              ],
            },
          },
          {
            content_id: "d6f8db55-5ff4-4e95-81e7-df2ac6d76a6b",
            title: "Stuart Andrew MP",
            base_path: "/government/people/stuart-andrew",
            details: {},
            links: {
              role_appointments: [
                current_role_appointment(
                  content_id: "849f0fdc-6393-49fa-9661-9afdfb40615c",
                  title: "Parliamentary Under Secretary of State",
                  base_path: "/government/ministers/parliamentary-under-secretary-of-state--94",
                  document_type: "ministerial_role",
                ),
              ],
            },
          },
        ],
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
                title: "Enquiries for overseas companies looking to set up in the UK",
                link: "https://invest.great.gov.uk/int/contact/",
              }],
            },
          },
        ],
        ordered_high_profile_groups: [
          {
            base_path: "/government/organisations/attorney-generals-office-1",
            title: "High Profile Group 1",
            details: { organisation_govuk_status: { status: "live" } },
          },
          {
            base_path: "/government/organisations/attorney-generals-office-2",
            title: "High Profile Group 2",
            details: { organisation_govuk_status: { status: "live" } },
          },
        ],
      },
    }

    @content_item_charity_commission = {
      title: "The Charity Commission",
      base_path: "/government/organisations/charity-commission",
      details: {
        body: "We register and regulate charities in England and Wales, to ensure that the public can support charities with confidence.\r\n",
        brand: "department-for-business-innovation-skills",
        logo: {
          formatted_title: "Charity Commission",
          image: {
            url: "https://assets.publishing.service.gov.uk/government/uploads/system/uploads/organisation/logo/98/Home_page.jpg",
            alt_text: "The Charity Commission",
          },
        },
        foi_exempt: true,
        organisation_govuk_status: {
          status: "live",
        },
        organisation_type: "non_ministerial_department",
        organisation_featuring_priority: "service",
        ordered_featured_links: [
          {
            title: "Find a charity",
            href: "http://apps.charitycommission.gov.uk/showcharity/registerofcharities/RegisterHomePage.aspx",
          },
          {
            title: "Online services and contact forms",
            href: "https://www.gov.uk/government/organisations/charity-commission/about/about-our-services",
          },
        ],
        ordered_featured_documents: [
          {
            title: "Charity annual return 2018",
            href: "/government/news/charity-annual-return-2018",
            image: {
              url: "https://assets.publishing.service.gov.uk/government/uploads/system/uploads/feature/image/63313/AR18_prepare_v1.1.png",
              alt_text: "Annual return service 2018",
            },
            summary: "How you can prepare for the 2018 annual return service, which will be available this summer. ",
            public_updated_at: "2018-06-06T10:56:00.000+01:00",
            document_type: "News story",
          },
        ],
        social_media_links: [
          {
            service_type: "twitter",
            title: "Twitter",
            href: "https://twitter.com/chtycommission",
          },
          {
            service_type: "youtube",
            title: "YouTube",
            href: "http://www.youtube.com/TheCharityCommission",
          },
        ],
      },
      links: {
        available_translations: [],
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
            web_url: "https://www.gov.uk/government/policies/waste-and-recycling",
          },
        ],
      },
    }

    @content_item_wales_office = {
      title: "Office of the Secretary of State for Wales",
      base_path: "/government/organisations/office-of-the-secretary-of-state-for-wales",
      details: {
        body: "The Office of the Secretary of State for Wales supports the Welsh Secretary",
        brand: "wales-office",
        logo: {
          formatted_title: "Office of the Secretary of State for Wales<br/>Swyddfa Ysgrifennydd Gwladol Cymru",
          crest: "single-identity",
        },
        organisation_govuk_status: {
          status: "live",
        },
        organisation_type: "non_ministerial_department",
        ordered_featured_links: [
          {
            title: "Wales Office Featured Link",
            href: "/wales/link/1",
          },
        ],
        ordered_featured_documents: [
          {
            title: "Welsh Secretary hails outstanding individuals in the Queen's Birthday Honours list",
            href: "/government/news/welsh-secretary-hails-outstanding-individuals-in-the-queens-birthday-honours-list",
            image: {
              url: "https://assets.publishing.service.gov.uk/government/uploads/system/uploads/feature/image/63372/GOV.UK_honours_web.jpg",
              alt_text: "Queen's Birthday Honours",
            },
            summary: "Alun Cairns: \"I'm proud to see people from all walks of Welsh life honoured today\".",
            public_updated_at: "2018-06-08T23:23:11.000+01:00",
            document_type: "Press release",
          },
        ],
        social_media_links: [
          {
            service_type: "twitter",
            title: "Twitter",
            href: "https://twitter.com/UKGovWales",
          },
          {
            service_type: "twitter",
            title: "Trydar",
            href: "https://twitter.com/LlywDUCymru",
          },
        ],
      },
      links: {
        available_translations: [
          {
            "base_path": "/government/organisations/office-of-the-secretary-of-state-for-wales.cy",
            "locale": "cy",
          },
          {
            "base_path": "/government/organisations/office-of-the-secretary-of-state-for-wales",
            "locale": "en",
          },
        ],
        ordered_contacts: [],
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
                  locality: "",
                  postal_code: "SW1A 2NP",
                },
                {
                  title: "Office of the Secretary of State for Wales Cardiff",
                  street_address: "White House\r\nCardiff",
                  locality: "",
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
              contact_form_links: [
                {
                  title: "",
                  link: "/foi_contact_link",
                  description: "",
                },
              ],
            },
          },
          {
            withdrawn: false,
            details: {
              description: "Something here\r\n\r\nSomething there",
              post_addresses: [
                {
                  title: "The Welsh Office",
                  street_address: "Green House\r\nBracknell",
                  locality: "",
                  postal_code: "B2 3ZZ",
                },
              ],
              email_addresses: [
                {
                  email: "welshofficefoi@walesoffice.gsi.gov.uk",
                },
              ],
              contact_form_links: [],
            },
          },
        ],
        ordered_roles: [
          { content_id: "61a62a60-df26-4454-81da-0594f0d74d76" },
        ],
        ordered_military_personnel: [
          {
            title: "Air Chief Marshal Sir  Stuart Peach GBE KCB ADC DL",
            base_path: "/government/people/stuart-peach",
            details: {},
            links: {
              role_appointments: [
                current_role_appointment(
                  content_id: "61a62a60-df26-4454-81da-0594f0d74d76",
                  title: "Chief of the Defence Staff",
                  document_type: "military_role",
                ),
              ],
            },
          },
        ],
      },
    }

    @content_item_wales_office_cy = @content_item_wales_office.deep_dup.tap do |cy|
      cy[:base_path] = "/government/organisations/office-of-the-secretary-of-state-for-wales.cy"
    end

    @content_item_separate_student_loans = org_example.deep_merge(
      "base_path" => "/government/organisations/student-loans-company",
      "title" => "Student Loans Company",
      "details" => {
        "organisation_govuk_status" => {
          "status" => "exempt",
          "url" => "http://www.slc.co.uk/",
          "updated_at" => nil,
        },
      },
    )

    @content_item_blank = {
      title: "An empty content item to test everything checks before trying to render things",
      base_path: "/government/organisations/civil-service-resourcing",
      details: {
        body: "",
        brand: "",
        logo: {
        },
        organisation_govuk_status: {
          status: "",
        },
      },
      links: {
      },
    }

    stub_content_store_has_item("/government/organisations/prime-ministers-office-10-downing-street", @content_item_no10)
    stub_content_store_has_item("/government/organisations/attorney-generals-office", @content_item_attorney_general)
    stub_content_store_has_item("/government/organisations/charity-commission", @content_item_charity_commission)
    stub_content_store_has_item("/government/organisations/office-of-the-secretary-of-state-for-wales", @content_item_wales_office)
    stub_content_store_has_item("/government/organisations/office-of-the-secretary-of-state-for-wales.cy", @content_item_wales_office_cy)
    stub_content_store_has_item("/government/organisations/civil-service-resourcing", @content_item_blank)
    stub_content_store_has_item("/government/organisations/student-loans-company", @content_item_separate_student_loans)

    stub_rummager_latest_content_requests("prime-ministers-office-10-downing-street")
    stub_rummager_latest_content_requests("attorney-generals-office")
    stub_rummager_latest_content_requests("charity-commission")
    stub_rummager_latest_content_requests("office-of-the-secretary-of-state-for-wales")
    stub_rummager_latest_content_requests("civil-service-resourcing")
    stub_rummager_latest_content_requests("student-loans-company")
  end

  it "doesn't fail if the content item is missing any data" do
    visit "/government/organisations/civil-service-resourcing"
    assert page.has_css?(".content")
  end

  it "includes description and autodiscovery meta tags" do
    visit "/government/organisations/prime-ministers-office-10-downing-street"

    page.assert_selector("meta[name='description'][content='10 Downing Street is the official residence of the British Prime Minister.']", visible: false)
    assert page.has_css?("link[rel='alternate'][type='application/json'][href$='/api/organisations/prime-ministers-office-10-downing-street']", visible: false)
    assert page.has_css?("link[rel='alternate'][type='application/atom+xml'][href$='/government/organisations/prime-ministers-office-10-downing-street.atom']", visible: false)
  end

  it "displays breadcrumbs" do
    visit "/government/organisations/prime-ministers-office-10-downing-street"

    within ".gem-c-breadcrumbs" do
      assert page.has_link?("Home", href: "/")
      assert page.has_link?("Organisations", href: "/government/organisations")
    end

    visit "/government/organisations/attorney-generals-office"
    assert page.has_css?(".govuk-breadcrumbs__link", text: "Organisations")

    visit "/government/organisations/charity-commission"
    assert page.has_css?(".govuk-breadcrumbs__link", text: "Organisations")
  end

  it "sets the page title" do
    visit "/government/organisations/prime-ministers-office-10-downing-street"
    assert page.has_title?("Prime Minister's Office, 10 Downing Street - GOV.UK")

    visit "/government/organisations/attorney-generals-office"
    assert page.has_title?("Attorney General's Office - GOV.UK")

    visit "/government/organisations/charity-commission"
    assert page.has_title?("Charity Commission - GOV.UK")
  end

  it "shows the no10 banner element only on no10's page" do
    visit "/government/organisations/prime-ministers-office-10-downing-street"
    assert page.has_css?(".organisation__no10-banner", text: "Prime Minister's Office, 10 Downing Street")

    visit "/government/organisations/attorney-generals-office"
    assert_not page.has_css?(".organisation__no10-banner")

    visit "/government/organisations/charity-commission"
    assert_not page.has_css?(".organisation__no10-banner")

    visit "/government/organisations/civil-service-resourcing"
    assert_not page.has_css?(".organisation__no10-banner")
  end

  it "renders the logo and logo brand correctly" do
    visit "/government/organisations/prime-ministers-office-10-downing-street"
    assert_not page.has_css?(".gem-c-organisation-logo")

    visit "/government/organisations/attorney-generals-office"
    assert page.has_css?(".gem-c-organisation-logo.brand--attorney-generals-office .gem-c-organisation-logo__name", text: "Attorney General's Office")

    visit "/government/organisations/charity-commission"
    assert page.has_css?(".gem-c-organisation-logo.brand--department-for-business-innovation-skills img[alt='The Charity Commission']")
  end

  it "shows featured links correctly if present" do
    visit "/government/organisations/prime-ministers-office-10-downing-street"
    assert_not page.has_css?(".app-c-topic-list")

    visit "/government/organisations/attorney-generals-office"
    assert page.has_css?("section#featured-documents")
    assert page.has_css?(".app-c-topic-list.app-c-topic-list--small .app-c-topic-list__link", text: "Attorney General's guidance to the legal profession")

    visit "/government/organisations/charity-commission"
    assert page.has_css?("section#featured-documents")
    assert page.has_css?(".app-c-topic-list .app-c-topic-list__link", text: "Find a charity")
    assert_not page.has_css?(".app-c-topic-list.app-c-topic-list--small")
  end

  it "shows the translation nav if required" do
    visit "/government/organisations/prime-ministers-office-10-downing-street"
    assert_not page.has_css?(".gem-c-translation-nav")

    visit "/government/organisations/attorney-generals-office"
    assert_not page.has_css?(".gem-c-translation-nav")

    visit "/government/organisations/office-of-the-secretary-of-state-for-wales.cy"
    assert page.has_css?(".gem-c-translation-nav")

    visit "/government/organisations/civil-service-resourcing"
    assert_not page.has_css?(".gem-c-translation-nav")
  end

  it "shows a large news item only on news organisations" do
    visit "/government/organisations/attorney-generals-office"
    assert page.has_css?(".gem-c-image-card.gem-c-image-card--large .gem-c-image-card__title", text: "New head of the Serious Fraud Office announced")

    visit "/government/organisations/charity-commission"
    assert page.has_css?(".gem-c-image-card .gem-c-image-card__title", text: "Charity annual return 2018")
    assert_not page.has_css?(".gem-c-image-card.gem-c-image-card--large .gem-c-image-card__title", text: "Charity annual return 2018")
  end

  it "shows the latest documents when it should" do
    visit "/government/organisations/attorney-generals-office"
    assert page.has_css?("section#latest-documents")
    assert page.has_css?(".gem-c-heading", text: "Latest from the Attorney General's Office")
    assert page.has_css?(".gem-c-document-list__item-title[href='/government/news/rapist-has-sentence-increased-after-solicitor-generals-referral']", text: "Rapist has sentence increased after Solicitor General’s referral")
    assert page.has_css?(".gem-c-document-list__attribute", text: "Press release")
    assert page.has_css?(".gem-c-document-list__attribute time[datetime='2018-06-18']", text: "18 June 2018")
  end

  it "shows a see all link in the latest documents section" do
    visit "/government/organisations/attorney-generals-office"
    assert page.has_css?("a[href='/search/all?organisations%5B%5D=attorney-generals-office&order=updated-newest&parent=attorney-generals-office']", text: "See all")
  end

  it "shows subscription links" do
    visit "/government/organisations/attorney-generals-office"
    assert page.has_css?(".gem-c-subscription-links__link[href='/email-signup?link=/government/organisations/attorney-generals-office']", text: "Get email alerts")
    assert page.has_css?(".gem-c-subscription-links__link[href='#']", text: "Subscribe to feed")
  end

  it "shows the 'what we do' section" do
    visit "/government/organisations/prime-ministers-office-10-downing-street"
    assert page.has_css?("section#what-we-do")
    assert page.has_content?(/10 Downing Street is the official residence and the office of the British Prime Minister/i)

    visit "/government/organisations/attorney-generals-office"
    assert page.has_css?("section#what-we-do")
    assert page.has_content?(/provides legal advice and support to the Attorney General/i)
  end

  it "shows latest documents by type" do
    visit "/government/organisations/attorney-generals-office"
    assert page.has_css?(".gem-c-heading", text: "Documents")
    assert page.has_css?(".gem-c-heading", text: "News and communications")
    assert page.has_css?(".gem-c-document-list__item-title[href='/content-item-1']", text: "Content item 1")
    assert page.has_css?(".gem-c-heading", text: "Transparency")
    assert page.has_css?(".gem-c-heading", text: "Guidance and regulation")
    assert_not page.has_css?(".gem-c-heading", text: "Services")
    assert_not page.has_css?(".gem-c-heading", text: "Statistics")
  end

  it "does not show the latest documents by type section if there are none" do
    stub_empty_rummager_requests("attorney-generals-office")
    visit "/government/organisations/attorney-generals-office"
    assert_not page.has_css?(".gem-c-heading", text: "Documents")
  end

  it "shows the ministers for an organisation" do
    visit "/government/organisations/attorney-generals-office"
    assert page.has_css?("div#people")
    assert page.has_css?(".gem-c-heading", text: "Our ministers")
    assert page.has_css?(".gem-c-image-card .gem-c-image-card__title-link", text: "Theresa May MP")
    assert page.has_css?(".gem-c-image-card .gem-c-image-card__title-link", text: "Stuart Andrew MP")
  end

  it "does not show the ministers section for no.10" do
    visit "/government/organisations/prime-ministers-office-10-downing-street"
    assert_not page.has_css?("div#people")
    assert_not page.has_css?(".gem-c-heading", text: "Our ministers")
    assert_not page.has_css?(".gem-c-image-card .gem-c-image-card__title-link", text: "Theresa May MP")
  end

  it "does not display ministers for organisations without minister data" do
    visit "/government/organisations/charity-commission"
    assert_not page.has_css?(".gem-c-heading", text: "Our ministers")
  end

  it "shows the non-ministers for an organisation" do
    visit "/government/organisations/attorney-generals-office"
    assert page.has_css?(".gem-c-heading", text: "Our management")
    assert page.has_css?(".gem-c-image-card .gem-c-image-card__title-link", text: "Sir Jeremy Heywood")
  end

  it "show a link to the correct about page on Welsh and English pages" do
    visit "/government/organisations/attorney-generals-office"
    assert page.has_css?("a[href='/government/organisations/attorney-generals-office/about']", text: "Read more about what we do")

    visit "/government/organisations/office-of-the-secretary-of-state-for-wales.cy"
    assert page.has_css?("a[href='/government/organisations/office-of-the-secretary-of-state-for-wales/about.cy']", text: "Darllen mwy am yr hyn rydyn ni'n ei wneud")
  end

  it "shows translated text on welsh pages" do
    visit "/government/organisations/office-of-the-secretary-of-state-for-wales.cy"
    assert page.has_css?(".gem-c-heading", text: "Ein huwch swyddogion milwrol")
    assert page.has_css?(".gem-c-image-card__title .gem-c-image-card__title-link[href='/government/people/stuart-peach']")
    assert page.has_css?(".gem-c-image-card__description", text: "Chief of the Defence Staff")
  end

  it "does not display non-ministers for an organisation if data not present" do
    visit "/government/organisations/attorney-generals-office"
    assert_not page.has_css?(".gem-c-heading", text: "Our senior military officials")
    assert_not page.has_css?(".gem-c-heading", text: "Chief professional officers")
    assert_not page.has_css?(".gem-c-heading", text: "Special representatives")
    assert_not page.has_css?(".gem-c-heading", text: "Traffic commissioners")

    visit "/government/organisations/office-of-the-secretary-of-state-for-wales"
    assert_not page.has_css?(".gem-c-heading", text: "Our management")
    assert_not page.has_css?(".gem-c-heading", text: "Chief professional officers")
    assert_not page.has_css?(".gem-c-heading", text: "Special representatives")
    assert_not page.has_css?(".gem-c-heading", text: "Traffic commissioners")
  end

  it "displays foi information correctly where required" do
    visit "/government/organisations/prime-ministers-office-10-downing-street"
    assert_not page.has_content?(/Make an FOI request/i)
    assert_not page.has_content?(/Freedom of Information (FOI) Act/i)

    visit "/government/organisations/charity-commission"
    assert page.has_css?("section#freedom-of-information")
    assert page.has_content?(/This organisation is not covered by the Freedom of Information Act. To see which organisations are included, see the legislation./i)

    visit "/government/organisations/office-of-the-secretary-of-state-for-wales.cy"
    assert page.has_content?(/Gwneud cais DRhG/i)
    assert page.has_css?("section#freedom-of-information")
    assert page.has_css?(".gem-c-heading", text: "FOI stuff")
    assert page.has_content?(/Office of the Secretary of State for Wales/i)
    assert page.has_content?(/Gwydyr House/i)
    assert page.has_content?(/Whitehall/i)
    assert page.has_content?(/SW1A 2NP/i)

    assert page.has_content?(/Office of the Secretary of State for Wales Cardiff/i)
    assert page.has_content?(/The Welsh Office/i)
    assert page.has_content?(/walesofficefoi@walesoffice.gsi.gov.uk/i)
    assert page.has_content?(/foiwales@walesoffice.gsi.gov.uk/i)
    assert page.has_content?(/welshofficefoi@walesoffice.gsi.gov.uk/i)
    assert page.has_css?("a[href='/foi_contact_link']", text: "Ffurflen cysylltu DRhG")
  end

  it "shows high profile groups section" do
    visit "/government/organisations/attorney-generals-office"
    assert page.has_css?("section#high-profile-groups")
    assert page.has_css?(".gem-c-heading", text: "High profile groups within AGO")
    assert page.has_css?(".app-c-topic-list__link[href='/government/organisations/attorney-generals-office-1']", text: "High Profile Group 1")
    assert page.has_css?(".app-c-topic-list__link[href='/government/organisations/attorney-generals-office-2']", text: "High Profile Group 2")
  end

  it "does not show section for organisations without high profile groups" do
    visit "/government/organisations/office-of-the-secretary-of-state-for-wales"
    assert_not page.has_css?(".gem-c-heading", text: "High profile groups within the Office of the Secretary of State for Wales")
  end

  it "does not show high profile groups for promotional orgs" do
    visit "/government/organisations/prime-ministers-office-10-downing-street"
    assert_not page.has_css?(".gem-c-heading", text: "High profile groups within the Prime Minister's Office, 10 Downing Street")
  end

  it "displays corporate information pages" do
    visit "/government/organisations/attorney-generals-office"
    assert page.has_css?("div#corporate-info")
    assert page.has_css?(".gem-c-heading", text: "Corporate information")
    assert page.has_css?(".app-c-topic-list__link[href='/complaints-procedure']", text: "Complaints procedure")

    assert page.has_css?(".gem-c-heading", text: "Jobs and contracts")
    assert page.has_css?(".app-c-topic-list__link[href='https://www.civilservicejobs.service.gov.uk/csr']", text: "Jobs")
  end

  it "does not show corporate information pages if none available" do
    visit "/government/organisations/office-of-the-secretary-of-state-for-wales"
    assert_not page.has_css?(".gem-c-heading", text: "Corporate information")
    assert_not page.has_css?(".gem-c-heading", text: "Jobs and contracts")
  end

  it "displays contact information" do
    visit "/government/organisations/attorney-generals-office"
    assert page.has_css?("section#org-contacts")
    assert page.has_css?("h2.gem-c-heading", text: "Contact AGO")
    assert page.has_css?("h3.gem-c-heading", text: "Department for International Trade")
    assert page.has_content?(/King Charles Street/i)
    assert page.has_content?(/Whitehall/i)
    assert page.has_content?(/SW1A 2AH/i)
    assert page.has_css?("a[href='https://invest.great.gov.uk/int/contact/']", text: "Contact Form: Department for International Trade")
    assert page.has_content?("enquiries@trade.gov.uk")
    assert page.has_content?("+44 (0) 20 7215 5000")
  end

  it "does not show contact information if none available" do
    visit "/government/organisations/office-of-the-secretary-of-state-for-wales"
    assert_not page.has_css?("h2.gem-c-heading", text: "Contact WO")

    visit "/government/organisations/charity-commission"
    assert_not page.has_css?("h2.gem-c-heading", text: "Contact Charity Commission")
  end

  it "shows promotional features on the right pages" do
    visit "/government/organisations/prime-ministers-office-10-downing-street"
    assert page.has_content?(/Greater transparency across government is at the heart of our commitment to let you hold politicians and public bodies to account./i)

    visit "/government/organisations/attorney-generals-office"
    assert_not page.has_content?(/Greater transparency across government is at the heart of our commitment to let you hold politicians and public bodies to account./i)
  end

  it "full org pages have GovernmentOrganization schema.org information" do
    visit "/government/organisations/prime-ministers-office-10-downing-street"

    schema_sections = page.find_all("script[type='application/ld+json']", visible: false)
    schemas = schema_sections.map { |section| JSON.parse(section.text(:all)) }

    org_schema = schemas.detect { |schema| schema["@type"] == "GovernmentOrganization" }
    assert_equal org_schema["name"], "Prime Minister's Office, 10 Downing Street"
  end

  it "separate website pages have GovernmentOrganization schema.org information" do
    visit "/government/organisations/student-loans-company"

    schema_sections = page.find_all("script[type='application/ld+json']", visible: false)
    schemas = schema_sections.map { |section| JSON.parse(section.text(:all)) }

    org_schema = schemas.detect { |schema| schema["@type"] == "GovernmentOrganization" }
    assert_equal org_schema["name"], "Student Loans Company"
  end
end
