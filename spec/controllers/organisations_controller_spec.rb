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
          logo: {},
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

      no_10_page_content ||= YAML.load_file(Rails.root.join("config/organisations_no_10_page/content_item.yml")).symbolize_keys
      stub_content_store_has_item(
        "/government/organisations/prime-ministers-office-10-downing-street",
        no_10_page_content,
        { max_age: 900, private: false },
      )
    end

    it "set correct expiry headers" do
      get :show, params: { organisation_name: "ministry-of-magic" }

      expect(response.headers["Cache-Control"]).to eq("max-age=900, public")
    end
  end
end
