RSpec.describe OrganisationsController do
  include SearchApiHelpers
  describe "GET index" do
    before do
      stub_content_store_has_item(
        "/government/organisations/ministry-of-magic",
        title: "Ministry of magic",
        base_path: "/government/organisations/ministry-of-magic",
        links: {},
        details: {
          body: "This organisation has a status of exempt.",
          logo: {
          },
          organisation_govuk_status: {
            status: "exempt",
            url: "https://ministry-of-magic.gov.uk",
          },
        },
      )

      stub_search(body: {
        "results" => [],
        "start" => 0,
        "total" => 0,
      })
    end

    it "set correct expiry headers" do
      get :show, params: { organisation_name: "ministry-of-magic" }

      expect(response.headers["Cache-Control"]).to eq("max-age=900, public")
    end
  end
end
