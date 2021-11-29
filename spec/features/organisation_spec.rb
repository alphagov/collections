require "integration_spec_helper"

RSpec.describe "Organisation pages" do
  include OrganisationHelpers

  let(:org_example) { organisation_content_schema_example("organisation") }
  let(:content_item_no10) { organisation_content_schema_example("number_10") }
  let(:content_item_attorney_general) { organisation_content_schema_example("attorney_general") }
  let(:content_item_charity_commission) { organisation_content_schema_example("charity_commission") }
  let(:content_item_wales_office) { organisation_content_schema_example("wales_office") }

  let(:content_item_wales_office_cy) do
    content_item_wales_office.deep_dup.tap do |cy|
      cy[:base_path] = "/government/organisations/office-of-the-secretary-of-state-for-wales.cy"
    end
  end

  let(:content_item_separate_student_loans) do
    org_example.deep_merge(
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
  end

  let(:content_item_blank) do
    {
      "title" => "An empty content item to test everything checks before trying to render things",
      "base_path" => "/government/organisations/civil-service-resourcing",
      "details" => {
        "body" => "",
        "brand" => "",
        "logo" => {},
        "organisation_govuk_status" => { "status" => "" },
      },
      "links" => {},
    }
  end

  before do
    stub_content_and_search(content_item_no10)
    stub_content_and_search(content_item_attorney_general)
    stub_content_and_search(content_item_charity_commission)
    stub_content_and_search(content_item_wales_office)
    stub_content_and_search(content_item_blank)
    stub_content_and_search(content_item_separate_student_loans)
    stub_content_store_has_item("/government/organisations/office-of-the-secretary-of-state-for-wales.cy", content_item_wales_office_cy)
  end

  it "doesn't fail if the content item is missing any data" do
    visit "/government/organisations/civil-service-resourcing"
    expect(page).to have_css(".content")
  end

  it "includes description and autodiscovery meta tags" do
    visit "/government/organisations/prime-ministers-office-10-downing-street"
    padded_string =
      "10 Downing Street is the official residence and the office of the British Prime Minister.\
      The office helps the Prime Minister to establish and deliver the government’s overall strategy and policy priorities,\
      and to communicate the government’s policies to Parliament, the public and international audiences."
    string = padded_string.gsub("      ", " ")
    expect(page).to have_selector("meta[name='description'][content='#{string}']", visible: :hidden)
    expect(page).to have_css("link[rel='alternate'][type='application/json'][href$='/api/organisations/prime-ministers-office-10-downing-street']", visible: :hidden)
    expect(page).to have_css("link[rel='alternate'][type='application/atom+xml'][href$='/government/organisations/prime-ministers-office-10-downing-street.atom']", visible: :hidden)
  end

  it "displays breadcrumbs" do
    visit "/government/organisations/prime-ministers-office-10-downing-street"

    within ".gem-c-breadcrumbs" do
      expect(page).to have_link("Home", href: "/")
      expect(page).to have_link(I18n.t("organisations.breadcrumbs.organisations"), href: "/government/organisations")
    end

    visit "/government/organisations/attorney-generals-office"
    expect(page).to have_css(".govuk-breadcrumbs__link", text: "Organisations")

    visit "/government/organisations/charity-commission"
    expect(page).to have_css(".govuk-breadcrumbs__link", text: "Organisations")
  end

  it "sets the page title" do
    visit "/government/organisations/prime-ministers-office-10-downing-street"
    expect(page).to have_title("Prime Minister's Office, 10 Downing Street - GOV.UK")

    visit "/government/organisations/attorney-generals-office"
    expect(page).to have_title("Attorney General's Office - GOV.UK")

    visit "/government/organisations/charity-commission"
    expect(page).to have_title("Charity Commission - GOV.UK")
  end

  describe "no10 banner" do
    it "shows only on no10's page" do
      visit "/government/organisations/prime-ministers-office-10-downing-street"
      expect(page).to have_css(".organisation__no10-banner", text: "Prime Minister's Office, 10 Downing Street")
    end

    it "doesn't show on other org pages" do
      visit "/government/organisations/attorney-generals-office"
      expect(page).not_to have_css(".organisation__no10-banner")

      visit "/government/organisations/charity-commission"
      expect(page).not_to have_css(".organisation__no10-banner")

      visit "/government/organisations/civil-service-resourcing"
      expect(page).not_to have_css(".organisation__no10-banner")
    end
  end

  it "renders the logo and logo brand correctly" do
    visit "/government/organisations/prime-ministers-office-10-downing-street"
    expect(page).not_to have_css(".gem-c-organisation-logo")

    visit "/government/organisations/attorney-generals-office"
    expect(page).to have_css(".gem-c-organisation-logo.brand--attorney-generals-office .gem-c-organisation-logo__name", text: "Attorney General's Office")

    visit "/government/organisations/charity-commission"
    expect(page).to have_css(".gem-c-organisation-logo.brand--department-for-business-innovation-skills img[alt='The Charity Commission']")
  end

  describe "featured documents and featured links" do
    before do
      content_item_no10["details"]["ordered_featured_documents"] = []
      content_item_no10["details"]["ordered_featured_links"] = []
      stub_content_store_has_item("/government/organisations/prime-ministers-office-10-downing-street", content_item_no10)
    end

    it "does not display them if they are absent from content item" do
      visit "/government/organisations/prime-ministers-office-10-downing-street"
      expect(page).not_to have_css("section#featured-documents")
      expect(page).not_to have_css(".app-c-topic-list.app-c-topic-list--small")
    end

    it "displays them if they are present" do
      visit "/government/organisations/attorney-generals-office"
      expect(page).to have_css("section#featured-documents")
      expect(page).to have_css(".app-c-topic-list.app-c-topic-list--small .app-c-topic-list__link", text: "Attorney General's guidance to the legal profession")

      visit "/government/organisations/charity-commission"
      expect(page).to have_css("section#featured-documents")
      expect(page).to have_css(".app-c-topic-list .app-c-topic-list__link", text: "Find a charity")
      expect(page).not_to have_css(".app-c-topic-list.app-c-topic-list--small")
    end
  end

  it "shows the translation nav if required" do
    visit "/government/organisations/prime-ministers-office-10-downing-street"
    expect(page).not_to have_css(".gem-c-translation-nav")

    visit "/government/organisations/attorney-generals-office"
    expect(page).not_to have_css(".gem-c-translation-nav")

    visit "/government/organisations/office-of-the-secretary-of-state-for-wales.cy"
    expect(page).to have_css(".gem-c-translation-nav")

    visit "/government/organisations/civil-service-resourcing"
    expect(page).not_to have_css(".gem-c-translation-nav")
  end

  it "shows a large news item only on news organisations" do
    visit "/government/organisations/attorney-generals-office"
    expect(page).to have_css(".gem-c-image-card.gem-c-image-card--large .gem-c-image-card__title", text: "Attorney General seeking feedback on new disclosure guidelines")

    visit "/government/organisations/charity-commission"
    expect(page).to have_css(".gem-c-image-card .gem-c-image-card__title", text: "Coronavirus (COVID-19): increased risk of fraud and cybercrime against charities")
    expect(page).not_to have_css(".gem-c-image-card.gem-c-image-card--large .gem-c-image-card__title", text: "Coronavirus (COVID-19): increased risk of fraud and cybercrime against charities")
  end

  it "shows the latest documents when it should" do
    visit "/government/organisations/attorney-generals-office"
    expect(page).to have_css("section#latest-documents")
    expect(page).to have_css(".gem-c-heading", text: "Latest from the Attorney General's Office")
    expect(page).to have_css(".gem-c-document-list__item-title[href='/government/news/attorney-general-launches-recruitment-campaign-for-new-chief-inspector']", text: "Attorney General launches recruitment campaign for new Chief Inspector")
    expect(page).to have_css(".gem-c-document-list__attribute", text: "Press release")
    expect(page).to have_css(".gem-c-document-list__attribute time[datetime='2020-07-26']", text: "26 July 2020")
  end

  it "shows a see all link in the latest documents section" do
    visit "/government/organisations/attorney-generals-office"
    expect(page).to have_css("a[href='/search/all?organisations%5B%5D=attorney-generals-office&order=updated-newest&parent=attorney-generals-office']", text: "See all")
  end

  it "shows subscription links" do
    visit "/government/organisations/attorney-generals-office"
    expect(page).to have_css("a[href='/email-signup?link=/government/organisations/attorney-generals-office']", text: "Get emails")
    expect(page).to have_css("button", text: "Subscribe to feed")
  end

  it "shows the 'what we do' section" do
    visit "/government/organisations/prime-ministers-office-10-downing-street"
    expect(page).to have_css("section#what-we-do")
    expect(page).to have_content(/10 Downing Street is the official residence and the office of the British Prime Minister/i)

    visit "/government/organisations/attorney-generals-office"
    expect(page).to have_css("section#what-we-do")
    expect(page).to have_content(/provides legal advice and support to the Attorney General/i)
  end

  it "shows latest documents by type" do
    visit "/government/organisations/attorney-generals-office"
    expect(page).to have_css(".gem-c-heading", text: "Documents")
    expect(page).to have_css(".gem-c-heading", text: "News and communications")
    expect(page).to have_css(".gem-c-document-list__item-title[href='/content-item-1']", text: "Content item 1")
    expect(page).to have_css(".gem-c-heading", text: "Transparency")
    expect(page).to have_css(".gem-c-heading", text: "Guidance and regulation")
    expect(page).not_to have_css(".gem-c-heading", text: "Services")
    expect(page).not_to have_css(".gem-c-heading", text: "Statistics")
  end

  it "does not show the latest documents by type section if there are none" do
    stub_empty_search_api_requests("attorney-generals-office")
    visit "/government/organisations/attorney-generals-office"
    expect(page).not_to have_css(".gem-c-heading", text: "Documents")
  end

  it "shows the ministers for an organisation" do
    visit "/government/organisations/attorney-generals-office"
    expect(page).to have_css("div#people")
    expect(page).to have_css(".gem-c-heading", text: "Our ministers")
    expect(page).to have_css(".gem-c-image-card .gem-c-image-card__title-link", text: "The Rt Hon Suella Braverman QC MP")
    expect(page).to have_css(".gem-c-image-card .gem-c-image-card__title-link", text: "The Rt Hon Michael Ellis QC MP")
  end

  it "does not show the ministers section for no.10" do
    visit "/government/organisations/prime-ministers-office-10-downing-street"
    expect(page).not_to have_css("div#people")
    expect(page).not_to have_css(".gem-c-heading", text: "Our ministers")
    expect(page).not_to have_css(".gem-c-image-card .gem-c-image-card__title-link", text: "Theresa May MP")
  end

  it "does not display ministers for organisations without minister data" do
    visit "/government/organisations/charity-commission"
    expect(page).not_to have_css(".gem-c-heading", text: "Our ministers")
  end

  it "shows the non-ministers for an organisation" do
    visit "/government/organisations/attorney-generals-office"
    expect(page).to have_css(".gem-c-heading", text: "Our management")
    expect(page).to have_css(".gem-c-image-card .gem-c-image-card__title-link", text: "Rowena Collins Rice")
  end

  it "show a link to the correct about page on Welsh and English pages" do
    visit "/government/organisations/attorney-generals-office"
    expect(page).to have_css("a[href='/government/organisations/attorney-generals-office/about']", text: "Read more about what we do")

    visit "/government/organisations/office-of-the-secretary-of-state-for-wales.cy"
    expect(page).to have_css("a[href='/government/organisations/office-of-the-secretary-of-state-for-wales/about.cy']", text: "Darllenwch fwy am beth rydyn ni'n wneud")
  end

  it "shows translated text on welsh pages" do
    visit "/government/organisations/office-of-the-secretary-of-state-for-wales.cy"
    expect(page).to have_css(".gem-c-heading", text: "Ein rheolwyr")
    expect(page).to have_css(".gem-c-image-card__title .gem-c-image-card__title-link[href='/government/people/peter-umbleya']")
    expect(page).to have_css(".gem-c-image-card__description", text: "Non-Executive Director")
  end

  it "does not display non-ministers for an organisation if data not present" do
    visit "/government/organisations/attorney-generals-office"
    expect(page).not_to have_css(".gem-c-heading", text: "Our senior military officials")
    expect(page).not_to have_css(".gem-c-heading", text: "Chief professional officers")
    expect(page).not_to have_css(".gem-c-heading", text: "Special representatives")
    expect(page).not_to have_css(".gem-c-heading", text: "Traffic commissioners")

    visit "/government/organisations/office-of-the-secretary-of-state-for-wales"
    expect(page).not_to have_css(".gem-c-heading", text: "Our senior military officials")
    expect(page).not_to have_css(".gem-c-heading", text: "Chief professional officers")
    expect(page).not_to have_css(".gem-c-heading", text: "Special representatives")
    expect(page).not_to have_css(".gem-c-heading", text: "Traffic commissioners")
  end

  describe "foi information" do
    before do
      content_item_charity_commission["details"]["foi_exempt"] = true
      stub_content_store_has_item("/government/organisations/charity-commission", content_item_charity_commission)
    end

    it "promotional organisations do not have FOI info" do
      visit "/government/organisations/prime-ministers-office-10-downing-street"
      expect(page).not_to have_content(/Make an FOI request/i)
      expect(page).not_to have_content(/Freedom of Information (FOI) Act/i)
    end

    it "organisations that are exempt display exemption information" do
      visit "/government/organisations/charity-commission"
      expect(page).to have_css("section#freedom-of-information")
      expect(page).to have_content(/This organisation is not covered by the Freedom of Information Act. To see which organisations are included, see the legislation./i)
    end

    it "organisations that are not exempt display FOI contact details" do
      visit "/government/organisations/office-of-the-secretary-of-state-for-wales.cy"
      expect(page).to have_content(/Gwneud cais Rhyddid Gwybodaeth/i)
      expect(page).to have_css("section#freedom-of-information")
      expect(page).to have_css(".gem-c-heading", text: "FOI requests")
      expect(page).to have_content(/Office of the Secretary of State for Wales/i)
      expect(page).to have_content(/Gwydyr House/i)
      expect(page).to have_content(/Whitehall/i)
      expect(page).to have_content(/SW1A 2NP/i)
      expect(page).to have_content(/walesofficefoi@ukgovwales.gov.uk/i)
    end
  end

  describe "high profile groups section" do
    visible_high_profile_groups = [
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
    ]

    non_visible_high_profile_groups = [
      {
        base_path: "/government/organisations/charity-commission-1",
        title: "High Profile Group 1",
        details: { organisation_govuk_status: { status: "replaced" } },
      },
    ]

    before do
      content_item_attorney_general["links"]["ordered_high_profile_groups"] = visible_high_profile_groups
      stub_content_store_has_item("/government/organisations/attorney-generals-office", content_item_attorney_general)

      content_item_charity_commission["links"]["ordered_high_profile_groups"] = non_visible_high_profile_groups
      stub_content_store_has_item("/government/organisations/charity-commission", content_item_charity_commission)
    end

    it "displays high profile groups if present" do
      visit "/government/organisations/attorney-generals-office"
      expect(page).to have_css("section#high-profile-groups")
      expect(page).to have_css(".gem-c-heading", text: "High profile groups within AGO")
      expect(page).to have_css(".app-c-topic-list__link[href='/government/organisations/attorney-generals-office-1']", text: "High Profile Group 1")
      expect(page).to have_css(".app-c-topic-list__link[href='/government/organisations/attorney-generals-office-2']", text: "High Profile Group 2")
    end

    it "does not show section for organisations without high profile groups" do
      visit "/government/organisations/office-of-the-secretary-of-state-for-wales"
      expect(page).not_to have_css(".gem-c-heading", text: "High profile groups within the Office of the Secretary of State for Wales")
    end

    it "does not show high profile groups for promotional orgs" do
      visit "/government/organisations/prime-ministers-office-10-downing-street"
      expect(page).not_to have_css(".gem-c-heading", text: "High profile groups within the Prime Minister's Office, 10 Downing Street")
    end

    it "does not show high profile groups if groups are non-live, exempt or transitioning" do
      visit "/government/organisations/charity-commission"
      expect(page).not_to have_css(".gem-c-heading", text: "High profile groups within Charity Commission")
    end
  end

  describe "corporate information" do
    before do
      content_item_wales_office["details"]["ordered_corporate_information_pages"] = []
      stub_content_store_has_item("/government/organisations/office-of-the-secretary-of-state-for-wales", content_item_wales_office)
    end

    it "shows corporate info if available" do
      visit "/government/organisations/attorney-generals-office"
      expect(page).to have_css("div#corporate-info")
      expect(page).to have_css(".gem-c-heading", text: "Corporate information")
      expect(page).to have_css(".app-c-topic-list__link[href='/government/organisations/attorney-generals-office/about/complaints-procedure']", text: "Complaints procedure")
      expect(page).to have_css(".gem-c-heading", text: "Jobs and contracts")
      expect(page).to have_css(".app-c-topic-list__link[href='https://www.civilservicejobs.service.gov.uk/csr']", text: "Jobs")
    end

    it "does not show corporate info pages if data is unavailable" do
      visit "/government/organisations/office-of-the-secretary-of-state-for-wales"
      expect(page).not_to have_css(".gem-c-heading", text: "Corporate information")
      expect(page).not_to have_css(".gem-c-heading", text: "Jobs and contracts")
    end
  end

  describe "contact information" do
    it "displays if present" do
      visit "/government/organisations/attorney-generals-office"
      expect(page).to have_css("section#org-contacts")
      expect(page).to have_css("h2.gem-c-heading", text: "Contact AGO")
      expect(page).to have_content(/102 Petty France/i)
      expect(page).to have_content(/London/i)
      expect(page).to have_content(/SW1H 9EA/i)
      expect(page).to have_content("correspondence@attorneygeneral.gov.uk")
      expect(page).to have_content("Telephone - 020 7271 2492")
    end

    it "is absent if data isn't available" do
      content_item_attorney_general["links"]["ordered_contacts"] = []
      stub_content_store_has_item("/government/organisations/attorney-generals-office", content_item_attorney_general)

      visit "/government/organisations/attorney-generals-office"
      expect(page).not_to have_css("h2.gem-c-heading", text: "Contact AGO")
    end
  end

  it "shows promotional features on the right pages" do
    visit "/government/organisations/prime-ministers-office-10-downing-street"
    expect(page).to have_content(/Greater transparency across government is at the heart of our commitment to let you hold politicians and public bodies to account./i)

    visit "/government/organisations/attorney-generals-office"
    expect(page).not_to have_content(/Greater transparency across government is at the heart of our commitment to let you hold politicians and public bodies to account./i)
  end

  it "full org pages have GovernmentOrganization schema.org information" do
    visit "/government/organisations/prime-ministers-office-10-downing-street"

    schema_sections = page.find_all("script[type='application/ld+json']", visible: false)
    schemas = schema_sections.map { |section| JSON.parse(section.text(:all)) }

    org_schema = schemas.detect { |schema| schema["@type"] == "GovernmentOrganization" }
    expect("Prime Minister's Office, 10 Downing Street").to eq(org_schema["name"])
  end

  it "separate website pages have GovernmentOrganization schema.org information" do
    visit "/government/organisations/student-loans-company"

    schema_sections = page.find_all("script[type='application/ld+json']", visible: false)
    schemas = schema_sections.map { |section| JSON.parse(section.text(:all)) }

    org_schema = schemas.detect { |schema| schema["@type"] == "GovernmentOrganization" }
    expect("Student Loans Company").to eq(org_schema["name"])
  end
end
