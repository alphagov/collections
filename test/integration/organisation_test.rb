require "integration_test_helper"

class OrganisationTest < ActionDispatch::IntegrationTest
  include OrganisationHelpers

  before do
    org_example = GovukSchemas::Example.find("organisation", example_name: "organisation")

    @content_item_no10 = GovukSchemas::Example.find("organisation", example_name: "number_10")

    @content_item_attorney_general = GovukSchemas::Example.find("organisation", example_name: "attorney_general")

    @content_item_charity_commission = GovukSchemas::Example.find("organisation", example_name: "charity_commission")

    @content_item_wales_office = GovukSchemas::Example.find("organisation", example_name: "wales_office")

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

    stub_search_api_latest_content_requests("prime-ministers-office-10-downing-street")
    stub_search_api_latest_content_requests("attorney-generals-office")
    stub_search_api_latest_content_requests("charity-commission")
    stub_search_api_latest_content_requests("office-of-the-secretary-of-state-for-wales")
    stub_search_api_latest_content_requests("civil-service-resourcing")
    stub_search_api_latest_content_requests("student-loans-company")
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
    assert page.has_css?(".gem-c-document-list__item-title[href='/government/news/attorney-general-launches-recruitment-campaign-for-new-chief-inspector']", text: "Attorney General launches recruitment campaign for new Chief Inspector")
    assert page.has_css?(".gem-c-document-list__attribute", text: "Press release")
    assert page.has_css?(".gem-c-document-list__attribute time[datetime='2020-07-26']", text: "26 July 2020")
  end

  it "shows a see all link in the latest documents section" do
    visit "/government/organisations/attorney-generals-office"
    assert page.has_css?("a[href='/search/all?organisations%5B%5D=attorney-generals-office&order=updated-newest&parent=attorney-generals-office']", text: "See all")
  end

  it "shows subscription links" do
    visit "/government/organisations/attorney-generals-office"
    assert page.has_css?("a[href='/email-signup?link=/government/organisations/attorney-generals-office']", text: "Get emails")
    assert page.has_css?("button", text: "Subscribe to feed")
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
    stub_empty_search_api_requests("attorney-generals-office")
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
