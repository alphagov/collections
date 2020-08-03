require "integration_test_helper"

class OrganisationStatusTest < ActionDispatch::IntegrationTest
  include OrganisationHelpers

  before do
    @content_item_changed_name = {
      title: "Changed name organisation",
      base_path: "/government/organisations/changed_name",
      details: {
        body: "This organisation has a status of changed_name.",
        logo: {
        },
        organisation_govuk_status: {
          status: "changed_name",
        },
      },
      links: {
        ordered_successor_organisations: [
          {
            title: "Successor",
            base_path: "/changed/name/successor",
          },
        ],
      },
    }

    @content_item_devolved = {
      title: "Devolved organisation",
      base_path: "/government/organisations/devolved",
      details: {
        body: "This organisation has a status of devolved.",
        logo: {
        },
        organisation_govuk_status: {
          status: "devolved",
        },
      },
      links: {
        ordered_successor_organisations: [
          {
            title: "Devolved Successor",
            base_path: "/devolved/successor",
          },
        ],
      },
    }

    @content_item_exempt_no_url = {
      title: "Exempt organisation",
      base_path: "/government/organisations/exempt-no-url",
      links: {},
      details: {
        body: "This organisation has a status of exempt.",
        logo: {
        },
        organisation_govuk_status: {
          status: "exempt",
          url: "",
        },
      },
    }

    @content_item_exempt = {
      title: "Exempt organisation",
      base_path: "/government/organisations/exempt",
      links: {},
      details: {
        body: "This organisation has a status of exempt.",
        logo: {
        },
        organisation_govuk_status: {
          status: "exempt",
          url: "http://www.google.com",
        },
      },
    }

    @content_item_joining = {
      title: "Joining organisation",
      base_path: "/government/organisations/joining",
      links: {},
      details: {
        body: "This organisation has a status of joining.",
        logo: {
        },
        organisation_govuk_status: {
          status: "joining",
        },
      },
    }

    @content_item_left_gov = {
      title: "Left_gov organisation",
      base_path: "/government/organisations/left_gov",
      links: {},
      details: {
        body: "This organisation has a status of left_gov.",
        logo: {
        },
        organisation_govuk_status: {
          status: "left_gov",
        },
      },
    }

    @content_item_merged = {
      title: "Merged organisation",
      base_path: "/government/organisations/merged",
      details: {
        body: "This organisation has a status of merged.",
        logo: {
        },
        organisation_govuk_status: {
          status: "merged",
          updated_at: "2016-03-31T00:00:00.000+01:00",
        },
      },
      links: {
        ordered_successor_organisations: [
          {
            title: "Merged Successor",
            base_path: "/merged/successor",
          },
        ],
      },
    }

    @content_item_split = {
      title: "Split organisation",
      base_path: "/government/organisations/split",
      details: {
        body: "This organisation has a status of split.",
        logo: {
        },
        organisation_govuk_status: {
          status: "split",
        },
      },
      links: {
        ordered_successor_organisations: [
          {
            title: "Split Successor1",
            base_path: "/split/successor1",
          },
          {
            title: "Split Successor2",
            base_path: "/split/successor2",
          },
          {
            title: "Split Successor3",
            base_path: "/split/successor3",
          },
        ],
      },
    }

    @content_item_no_longer_exists = {
      title: "No_longer_exists organisation",
      base_path: "/government/organisations/no_longer_exists",
      links: {},
      details: {
        body: "This organisation has a status of no_longer_exists.",
        logo: {
        },
        organisation_govuk_status: {
          status: "no_longer_exists",
        },
      },
    }

    @content_item_replaced = {
      title: "Replaced organisation",
      base_path: "/government/organisations/replaced",
      details: {
        body: "This organisation has a status of replaced.",
        logo: {
        },
        organisation_govuk_status: {
          status: "replaced",
        },
      },
      links: {
        ordered_successor_organisations: [
          {
            title: "Replaced Successor",
            base_path: "/replaced/successor",
          },
        ],
      },
    }

    @content_item_documents = {
      title: "Fire Service College",
      base_path: "/government/organisations/fire-service-college",
      links: {},
      details: {
        body: "The Fire Service College (FSC) supplies specialist fire and rescue training to the UK's own fire and rescue services, the private security sector and the international market.\r\n\r\nThe college was formerly an executive agency of the Department for Communities and Local Government and was sold to Capita on 28 February 2013.<abbr title=\"Fire Service College\">FSC</abbr>",
        brand: "null",
        logo: {
          formatted_title: "Fire Service College",
        },
        organisation_govuk_status: {
          status: "exempt",
          url: "http://www.google.com",
          updated_at: "null",
        },
      },
    }

    stub_content_store_has_item("/government/organisations/changed_name", @content_item_changed_name)
    stub_content_store_has_item("/government/organisations/devolved", @content_item_devolved)
    stub_content_store_has_item("/government/organisations/exempt", @content_item_exempt)
    stub_content_store_has_item("/government/organisations/exempt-no-url", @content_item_exempt_no_url)
    stub_content_store_has_item("/government/organisations/joining", @content_item_joining)
    stub_content_store_has_item("/government/organisations/left_gov", @content_item_left_gov)
    stub_content_store_has_item("/government/organisations/merged", @content_item_merged)
    stub_content_store_has_item("/government/organisations/split", @content_item_split)
    stub_content_store_has_item("/government/organisations/no_longer_exists", @content_item_no_longer_exists)
    stub_content_store_has_item("/government/organisations/replaced", @content_item_replaced)
    stub_content_store_has_item("/government/organisations/fire-service-college", @content_item_documents)

    stub_rummager_latest_content_requests("changed_name")
    stub_rummager_latest_content_requests("devolved")
    stub_rummager_latest_content_requests("exempt")
    stub_rummager_latest_content_requests("exempt-no-url")
    stub_rummager_latest_content_requests("joining")
    stub_rummager_latest_content_requests("left_gov")
    stub_rummager_latest_content_requests("merged")
    stub_rummager_latest_content_requests("split")
    stub_rummager_latest_content_requests("no_longer_exists")
    stub_rummager_latest_content_requests("replaced")
    stub_rummager_latest_content_requests("fire-service-college")
  end

  it "displays a changed_name organisation page correctly" do
    visit "/government/organisations/changed_name"
    assert page.has_css?(".gem-c-organisation-logo")
    assert page.has_css?(".gem-c-notice", text: "Changed name organisation is now called Successor")
    assert page.has_css?(".gem-c-notice a[href='/changed/name/successor']", text: "Successor")
    assert page.has_css?(".gem-c-govspeak")
    assert page.has_content?(/This organisation has a status of changed_name./i)
  end

  it "displays a closed and devolved organisation page correctly" do
    visit "/government/organisations/devolved"
    assert page.has_css?(".gem-c-organisation-logo")
    assert page.has_css?(".gem-c-notice", text: "Devolved organisation is a body of Devolved Successor")
    assert page.has_css?(".gem-c-notice a[href='/devolved/successor']", text: "Devolved Successor")
    assert page.has_css?(".gem-c-govspeak")
    assert page.has_content?(/This organisation has a status of devolved./i)
  end

  it "displays an exempt organisation page correctly" do
    visit "/government/organisations/exempt"
    assert page.has_css?(".gem-c-organisation-logo")
    assert page.has_css?(".gem-c-notice", text: "Exempt organisation has a separate website")
    assert page.has_css?(".gem-c-notice a[href='http://www.google.com']", text: "separate website")
    assert page.has_css?(".gem-c-govspeak")
    assert page.has_content?(/This organisation has a status of exempt./i)
  end

  it "displays an exempt organisation page with no URL correctly" do
    visit "/government/organisations/exempt-no-url"
    assert page.has_css?(".gem-c-organisation-logo")
    assert page.has_css?(".gem-c-notice__title", text: "Exempt organisation has no website")
    assert page.has_css?(".gem-c-govspeak")
    assert page.has_content?(/This organisation has a status of exempt./i)
  end

  it "displays a joining organisation page correctly" do
    visit "/government/organisations/joining"
    assert page.has_css?(".gem-c-organisation-logo")
    assert page.has_css?(".gem-c-notice", text: "Joining organisation will soon be incorporated into GOV.UK")
    assert_not page.has_css?(".gem-c-notice a")
    assert page.has_css?(".gem-c-govspeak")
    assert page.has_content?(/This organisation has a status of joining./i)
    assert_not page.has_css?(".gem-c-heading", text: "Documents")
    assert_not page.has_css?(".gem-c-heading", text: "News and communications")
    assert_not page.has_css?(".gem-c-document-list__item-title[href='/content-item-1']", text: "Content item 1")
    assert_not page.has_css?(".gem-c-heading", text: "Transparency")
    assert_not page.has_css?(".gem-c-heading", text: "Guidance and regulation")
  end

  it "displays a left_gov organisation page correctly" do
    visit "/government/organisations/left_gov"
    assert page.has_css?(".gem-c-organisation-logo")
    assert page.has_css?(".gem-c-notice", text: "Left_gov organisation is now independent of the UK government")
    assert_not page.has_css?(".gem-c-notice a")
    assert page.has_css?(".gem-c-govspeak")
    assert page.has_content?(/This organisation has a status of left_gov./i)
  end

  it "displays a merged organisation page correctly" do
    visit "/government/organisations/merged"
    assert page.has_css?(".gem-c-organisation-logo")
    assert page.has_css?(".gem-c-notice", text: "Merged organisation became part of Merged Successor in March 2016")
    assert page.has_css?(".gem-c-notice a[href='/merged/successor']", text: "Merged Successor")
    assert page.has_css?(".gem-c-govspeak")
    assert page.has_content?(/This organisation has a status of merged./i)
  end

  it "displays a split organisation page correctly" do
    visit "/government/organisations/split"
    assert page.has_css?(".gem-c-organisation-logo")
    assert page.has_css?(".gem-c-notice", text: "Split organisation was replaced by Split Successor1, Split Successor2, and Split Successor3")
    assert page.has_css?(".gem-c-notice a[href='/split/successor1']", text: "Split Successor1")
    assert page.has_css?(".gem-c-notice a[href='/split/successor2']", text: "Split Successor2")
    assert page.has_css?(".gem-c-notice a[href='/split/successor3']", text: "Split Successor3")
    assert page.has_css?(".gem-c-govspeak")
    assert page.has_content?(/This organisation has a status of split./i)
  end

  it "displays a no_longer_exists organisation page correctly" do
    visit "/government/organisations/no_longer_exists"
    assert page.has_css?(".gem-c-organisation-logo")
    assert page.has_css?(".gem-c-notice", text: "No_longer_exists organisation has closed")
    assert_not page.has_css?(".gem-c-notice a")
    assert page.has_css?(".gem-c-govspeak")
    assert page.has_content?(/This organisation has a status of no_longer_exists./i)
  end

  it "displays a replaced organisation page correctly" do
    visit "/government/organisations/replaced"
    assert page.has_css?(".gem-c-organisation-logo")
    assert page.has_css?(".gem-c-notice", text: "Replaced organisation was replaced by Replaced Successor")
    assert page.has_css?(".gem-c-notice a[href='/replaced/successor']", text: "Replaced Successor")
    assert page.has_css?(".gem-c-govspeak")
    assert page.has_content?(/This organisation has a status of replaced./i)
  end

  it "shows latest documents by type on separate website page" do
    visit "/government/organisations/fire-service-college"
    assert page.has_css?(".gem-c-heading", text: "Documents")
    assert page.has_css?(".gem-c-heading", text: "News and communications")
    assert page.has_css?(".gem-c-document-list__item-title[href='/content-item-1']", text: "Content item 1")
    assert page.has_css?(".gem-c-heading", text: "Transparency")
    assert page.has_css?(".gem-c-heading", text: "Guidance and regulation")
    assert_not page.has_css?(".gem-c-heading", text: "Services")
    assert_not page.has_css?(".gem-c-heading", text: "Statistics")
  end
end
