RSpec.describe FeedsController, type: :routing do
  it "routing handles paths with just format" do
    expect(get: "/government/organisations/ministry-of-magic.atom").to route_to(
      controller: "feeds",
      action: "organisation",
      organisation_name: "ministry-of-magic",
      format: "atom",
    )
  end

  it "routing handles paths with format and locale" do
    expect(get: "/government/organisations/ministry-of-magic.cy.atom").to route_to(
      controller: "feeds",
      action: "organisation",
      organisation_name: "ministry-of-magic",
      format: "atom",
      locale: "cy",
    )
  end
end

RSpec.describe FeedsController, type: :controller do
  include OrganisationFeedHelpers
  render_views
  it "renders atom feeds" do
    content_item = content_store_has_schema_example("organisation")
    stub_content_for_organisation_feed("ministry-of-magic", [])

    get :organisation, params: { organisation_name: organisation_slug(content_item), format: "atom" }

    expect(response).to have_http_status(:success)
    expect(response.body).to match(/<title>Ministry of Magic - Activity on GOV.UK<\/title>/)
  end

  it "sets the Access-Control-Allow-Origin header for atom pages" do
    content_item = content_store_has_schema_example("organisation")
    stub_content_for_organisation_feed("ministry-of-magic", [])

    get :organisation, params: { organisation_name: organisation_slug(content_item), format: "atom" }

    expect(response.headers["Access-Control-Allow-Origin"]).to eq("*")
  end

  def organisation_slug(content_item)
    File.basename(content_item["base_path"])
  end

  def content_store_has_schema_example(schema_name)
    document = GovukSchemas::Example.find(schema_name, example_name: schema_name)
    document["base_path"] = "/government/organisations/ministry-of-magic"
    document["title"] = "Ministry of Magic"
    stub_content_store_has_item(document["base_path"], document)
    document
  end
end
