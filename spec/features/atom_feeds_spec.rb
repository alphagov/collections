require "integration_spec_helper"

feature "Atom feeds" do
  include OrganisationFeedHelpers

  scenario "renders an organisation atom feed when there is content" do
    given_there_is_an_organisation_content_item
    and_content_for_that_organisation
    when_i_visit_the_organisation_atom_feed
    then_i_can_see_the_feed
    with_the_feed_updated_time_set_to_the_latest_item
    and_feed_items
  end

  scenario "renders a global atom feed when there is content" do
    given_there_is_a_government_feed
    when_i_visit_the_government_atom_feed
    then_i_can_see_the_government_feed
    with_the_feed_updated_time_set_to_the_latest_item
    and_feed_items
  end

  scenario "renders a valid organisation atom feed when there is no content" do
    given_there_is_an_organisation_content_item
    but_no_content_for_that_organisation
    when_i_visit_the_organisation_atom_feed
    then_i_can_see_the_feed
    but_no_feed_items
  end

  def given_there_is_an_organisation_content_item
    @updated_at = "2018-12-25T00:00:00Z"
    @organisation_slug = "ministry-of-magic"
    @base_path = "/government/organisations/#{@organisation_slug}"

    content_store_has_schema_example("organisation")
  end

  def given_there_is_a_government_feed
    @updated_at = "2018-12-25T00:00:00Z"

    Services.search_api.stubs(:search)
      .with(
        start: 0,
        count: 20,
        fields: %w[title link description display_type public_timestamp],
        reject_content_purpose_supergroup: "other",
        order: "-public_timestamp",
      )
      .returns(
        "results" => results_from_search_api,
        "start" => 0,
        "total" => results_from_search_api.size,
      )

    @base_path = "/government/feed"
  end

  def and_content_for_that_organisation
    stub_content_for_organisation_feed(@organisation_slug, results_from_search_api)
  end

  def but_no_content_for_that_organisation
    stub_empty_results
  end

  def when_i_visit_the_organisation_atom_feed
    visit "#{@base_path}.atom"
  end

  def when_i_visit_the_government_atom_feed
    visit @base_path
  end

  def then_i_can_see_the_government_feed
    title = page.first("feed title").text(:all)
    expect("Activity on GOV.UK").to eq(title)
  end

  def then_i_can_see_the_feed
    with_a_title
    and_an_alternate_link
  end

  def with_a_title
    title = page.first("feed title").text(:all)
    expect("Ministry of Magic - Activity on GOV.UK").to eq(title)
  end

  def and_an_alternate_link
    expect(page.has_css?("feed link[rel='alternate'][href$='#{@base_path}']")).to be(true)
  end

  def with_the_feed_updated_time_set_to_the_latest_item
    updated = page.first("feed updated").text(:all)
    expect(@updated_at).to eq(updated)
  end

  def and_feed_items
    with_an_id
    and_a_title
    and_a_summary
    and_an_updated_time
  end

  def with_an_id
    id = page.first("feed entry id").text(:all)
    expect(id).to include("/government/collections/owl-and-newt-examinations-at-hogwarts##{@updated_at}")
  end

  def and_a_title
    title = page.first("feed entry title").text(:all)
    expect(title).to eq("Detailed guide: OWL and NEWT qualifications, Ministry of Magic")
  end

  def and_a_summary
    summary = page.first("feed entry summary").text(:all)
    expect(summary).to eq("This series brings together all documents relating to OWL and NEWT syllabuses, examinations and grading")
  end

  def and_an_updated_time
    updated = page.first("feed entry updated").text(:all)
    expect(@updated_at).to eq(updated)
  end

  def but_no_feed_items
    expect(page.has_css?("feed entry")).to be(false)
  end

  def content_store_has_schema_example(schema_name)
    document = GovukSchemas::Example.find(schema_name, example_name: schema_name)
    document["base_path"] = "/government/organisations/ministry-of-magic"
    document["title"] = "Ministry of Magic"
    stub_content_store_has_item(document["base_path"], document)
    document
  end

  def results_from_search_api
    [
      {
        "content_store_document_type" => "document_collection",
        "description" => "This series brings together all documents relating to OWL and NEWT syllabuses, examinations and grading",
        "display_type" => "Detailed guide",
        "link" => "/government/collections/owl-and-newt-examinations-at-hogwarts",
        "organisations" => [
          {
            "organisation_brand" => @organisation_slug,
            "logo_formatted_title" => "Ministry of Magic",
            "organisation_crest" => "single-identity",
            "title" => "Ministry of Magic",
            "content_id" => "96ae61d6-c2a1-48cb-8e67-da9d105ae381",
            "link" => @base_path,
            "slug" => @organisation_slug,
            "organisation_type" => "ministerial_department",
            "organisation_state" => "live",
          },
        ],
        "public_timestamp" => @updated_at,
        "title" => "OWL and NEWT qualifications, Ministry of Magic",
        "index" => "government",
        "es_score" => nil,
        "_id" => "/government/collections/owl-and-newt-examinations-at-hogwarts",
        "elasticsearch_type" => "edition",
        "document_type" => "edition",
      },
      {
        "content_store_document_type" => "detailed_guide",
        "description" => "Defence against the dark arts: Angry acolytes to deepening dread",
        "display_type" => "Detailed guide",
        "link" => "/government/guidance/dark-arts-acolytes-to-dread",
        "organisations" => [
          {
            "organisation_brand" => @organisation_slug,
            "logo_formatted_title" => "Ministry of Magic",
            "organisation_crest" => "single-identity",
            "title" => "Ministry of Magic",
            "content_id" => "96ae61d6-c2a1-48cb-8e67-da9d105ae381",
            "link" => @base_path,
            "slug" => @organisation_slug,
            "organisation_type" => "ministerial_department",
            "organisation_state" => "live",
          },
        ],
        "public_timestamp" => "2018-12-26T12:23:34+01:00",
        "title" => "Dealing with you know who, Ministry of Magic",
        "index" => "government",
        "es_score" => nil,
        "_id" => "/government/guidance/dark-arts-acolytes-to-dread",
        "elasticsearch_type" => "edition",
        "document_type" => "edition",
      },
    ]
  end
end
