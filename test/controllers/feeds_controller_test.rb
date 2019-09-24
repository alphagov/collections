require "test_helper"

class FeedsControllerTest < ActionController::TestCase
  include OrganisationFeedHelpers

  test "routing handles paths with just format" do
    assert_routing(
      "/government/organisations/ministry-of-magic.atom",
      controller: "feeds",
      action: "organisation",
      organisation_name: "ministry-of-magic",
      format: "atom",
    )
  end

  test "routing handles paths with format and locale" do
    assert_routing(
      "/government/organisations/ministry-of-magic.cy.atom",
      controller: "feeds",
      action: "organisation",
      organisation_name: "ministry-of-magic",
      format: "atom",
      locale: "cy",
    )
  end

  test "renders atom feeds" do
    content_item = content_store_has_schema_example("organisation")
    stub_content_for_organisation_feed("ministry-of-magic", [])

    get :organisation, params: { organisation_name: organisation_slug(content_item), format: "atom" }

    assert_response :success
    assert_select "feed title", "Ministry of Magic - Activity on GOV.UK"
  end

  test "sets the Access-Control-Allow-Origin header for atom pages" do
    content_item = content_store_has_schema_example("organisation")
    stub_content_for_organisation_feed("ministry-of-magic", [])

    get :organisation, params: { organisation_name: organisation_slug(content_item), format: "atom" }

    assert_equal "*", response.headers["Access-Control-Allow-Origin"]
  end


  def organisation_slug(content_item)
    File.basename(content_item["base_path"])
  end

  def content_store_has_schema_example(schema_name)
    document = GovukSchemas::Example.find(schema_name, example_name: schema_name)
    document["base_path"] = "/government/organisations/ministry-of-magic"
    document["title"] = "Ministry of Magic"
    content_store_has_item(document["base_path"], document)
    document
  end
end
