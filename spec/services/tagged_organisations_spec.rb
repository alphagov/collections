RSpec.describe TaggedOrganisations do
  include SearchApiHelpers

  describe "#fetch" do
    let(:taxon_content_id) { "c3c860fc-a271-4114-b512-1c48c0f82564" }
    let(:tagged_organisations) { described_class.new(taxon_content_id) }
    let(:params) do
      {
        aggregate_organisations: "1000",
        count: "0",
        filter_part_of_taxonomy_tree: [taxon_content_id],
      }
    end

    it "return tagged organisations" do
      search_results = {
        "results" => [],
        "aggregates" => {
          "organisations" => {
            "options" => [{
              "value" => {
                "title" => "Department for Education",
                "content_id" => "ebd15ade-73b2-4eaf-b1c3-43034a42eb37",
                "link" => "/government/organisations/department-for-education",
                "slug" => "department-for-education",
                "organisation_state" => "live",
              },
              "documents" => 89,
            }],
          },
        },
      }

      stub_search(params:, body: search_results)

      organisations = tagged_organisations.fetch
      expect(organisations.count).to eq(1)
      expect(organisations.first.title).to eq("Department for Education")
      expect(organisations.first.document_count).to eq(89)
    end

    it "only returns live organisations" do
      search_results = {
        "aggregates" => {
          "organisations" => {
            "options" => [
              {
                "value" => {
                  "organisation_state" => "live",
                },
              },
              {
                "value" => {
                  "organisation_state" => "closed",
                },
              },
            ],
          },
        },
      }

      stub_search(params:, body: search_results)

      organisations = tagged_organisations.fetch
      expect(organisations.count).to eq(1)
    end
  end
end
