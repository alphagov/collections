require 'integration_test_helper'

class OrganisationTest < ActionDispatch::IntegrationTest
  before do
    @content_item = {
        title: "Prime Minister's Office, 10 Downing Street",
        base_path: "/government/organisations/prime-ministers-office-10-downing-street",
        links: {
            ordered_contacts: [],
            ordered_parent_organisations: [],
            ordered_featured_policies: [],
            ordered_child_organisations: [
                {
                    title: "Committee on Standards in Public Life"
                },
                {
                    title: "Office of the Leader of the House of Commons"
                }
            ]
        },
        details: {
            body: "10 Downing Street is the official residence and the office of the British Prime Minister.",
            brand: "cabinet-office",
            logo: {
                formatted_title: "Prime Minister&#39;s Office, 10 Downing Street",
                crest: "eo"
            },
            foi_exempt: false,
            ordered_corporate_information_pages: [],
            ordered_featured_links: [],
            ordered_featured_documents: [],
            ordered_ministers: [
                {
                    name_prefix: "The Rt Hon",
                    name: "Theresa May MP",
                    role: "Prime Minister",
                    href: "/government/people/theresa-may",
                    role_href: "/government/ministers/prime-minister",
                    image: {
                        url: "https://assets.publishing.service.gov.uk/government/uploads/system/uploads/
                              person/image/6/PM_portrait_960x640.jpg",
                        alt_text: "Theresa May MP"
                    }
                }
            ],
            ordered_board_members: [],
            organisation_govuk_status: {
                status: "live",
            },
            organisation_type: "executive_office",
            social_media_links: []
        }
    }

    content_store_has_item('/government/organisations/prime-ministers-office-10-downing-street', @content_item)
  end

  it "is possible to visit the organisations index page, which includes title" do
    visit "/government/organisations/prime-ministers-office-10-downing-street"
    assert page.has_title?("Prime Minister's Office, 10 Downing Street - GOV.UK")
  end

  it "is possible to visit the organisation page and return 200" do
    visit "/government/organisations/prime-ministers-office-10-downing-street"
    assert_equal 200, page.status_code
  end

  it "displays the organisation title" do
    visit "/government/organisations/prime-ministers-office-10-downing-street"
    assert page.has_content?(@content_item[:title])
  end

  it "current path matches base path" do
    visit "/government/organisations/prime-ministers-office-10-downing-street"
    assert_equal page.current_path, @content_item[:base_path]
  end

  it "displays ministers" do
    visit "/government/organisations/prime-ministers-office-10-downing-street"
    assert page.has_selector?(".organisation-ministers", text: "Theresa May MP")
  end

  it "displays child organisations count" do
    visit "/government/organisations/prime-ministers-office-10-downing-street"
    assert page.has_selector?(".child-organisation-count", text: "2")
  end

  it "does not display child organisations count" do
    content_item_without_child_orgs = {
        title: "Prime Minister's Office, 10 Downing Street",
        base_path: "/government/organisations/prime-ministers-office-10-downing-street",
        links: {
            ordered_contacts: [],
            ordered_parent_organisations: []
        },
        details: {
            body: "",
            logo: {
                formatted_title: "Prime Minister&#39;s Office, 10 Downing Street",
                crest: "eo"
            },
            foi_exempt: false,
            ordered_corporate_information_pages: [],
            ordered_featured_links: [],
            ordered_featured_documents: [],
            ordered_ministers: [],
            ordered_board_members: [],
            organisation_govuk_status: {
                status: "live",
            },
            organisation_type: "executive_office",
            social_media_links: []
        }
    }
    content_store_has_item('/government/organisations/prime-ministers-office-10-downing-street', content_item_without_child_orgs)
    visit "/government/organisations/prime-ministers-office-10-downing-street"
    assert page.has_no_css?(".child-organisation-count")
  end

  it "does not display featured policies" do
    visit "/government/organisations/prime-ministers-office-10-downing-street"
    assert page.has_no_css?(".organisation-policies")
  end

  it "displays featured policies" do
    content_item_with_empty_featured_policies = {
        title: "Prime Minister's Office, 10 Downing Street",
        base_path: "/government/organisations/prime-ministers-office-10-downing-street",
        links: {
            ordered_contacts: [],
            ordered_parent_organisations: [],
            ordered_featured_policies: [
                {
                    title: "Counter-terrorism",
                    base_path: "/government/policies/counter-terrorism"
                },
                {
                    title: "Central government efficiency",
                    base_path: "/government/policies/central-government-efficiency"
                }
            ]
        },
        details: {
            body: "",
            logo: {
                formatted_title: "Prime Minister&#39;s Office, 10 Downing Street",
                crest: "eo"
            },
            foi_exempt: false,
            ordered_corporate_information_pages: [],
            ordered_featured_links: [],
            ordered_featured_documents: [],
            ordered_ministers: [],
            ordered_board_members: [],
            organisation_govuk_status: {
                status: "live",
            },
            organisation_type: "executive_office",
            social_media_links: []
        }
    }
    content_store_has_item('/government/organisations/prime-ministers-office-10-downing-street', content_item_with_empty_featured_policies)
    visit "/government/organisations/prime-ministers-office-10-downing-street"
    assert page.has_css?(".organisation-policies")
  end
end
