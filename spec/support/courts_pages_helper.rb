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
    assert page.has_css?(".govuk-breadcrumbs--collapse-on-mobile")
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
