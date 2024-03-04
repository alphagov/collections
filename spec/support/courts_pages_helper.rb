module CourtPagesHelper
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
    expect(page).to have_selector(".govuk-breadcrumbs--collapse-on-mobile")
  end

  def i_see_the_courts_breadcrumb
    expect(page).to have_selector(".gem-c-breadcrumbs", text: I18n.t("organisations.breadcrumbs.courts_and_tribunals"))
  end

  def the_correct_title
    expect(page).to have_title("#{@title} - GOV.UK")
    expect(page).to have_selector(".gem-c-organisation-logo", text: @title)

    # Does not have the No. 10 banner
    expect(page).not_to have_selector(".organisation__no10-banner")
  end

  def the_courts_title
    expect(page).to have_title("#{@title} - GOV.UK")
    expect(page).to have_selector(".gem-c-title__text", text: @title)
  end

  def and_featured_links
    expect(page).to have_selector(".app-c-document-navigation-list")
  end

  def and_the_what_we_do_section
    expect(page).to have_selector("section#what-we-do", text: @what_we_do)
  end

  def and_contacts
    expect(page).to have_selector("section#org-contacts")
  end

  def and_there_is_schema_org_information
    schema_sections = page.find_all("script[type='application/ld+json']", visible: false)
    schemas = schema_sections.map { |section| JSON.parse(section.text(:all)) }

    org_schema = schemas.detect { |schema| schema["@type"] == "GovernmentOrganization" }
    assert_equal org_schema["name"], @title
  end

  def but_no_documents
    expect(page).not_to have_selector("section#latest-documents")
    expect(page).not_to have_selector(".gem-c-heading", text: "Documents")
    expect(page).not_to have_selector(".gem-c-heading", text: "Our announcements")
    expect(page).not_to have_selector(".gem-c-heading", text: "Our consultations")
    expect(page).not_to have_selector(".gem-c-heading", text: "Our publications")
    expect(page).not_to have_selector(".gem-c-heading", text: "Our statistics")
  end

  def or_foi_section
    expect(page).not_to have_content(/Make an FOI request/i)
    expect(page).not_to have_content(/Freedom of Information (FOI) Act/i)
  end

  def or_corporate_information
    expect(page).not_to have_selector("div#corporate-info")
  end
end
