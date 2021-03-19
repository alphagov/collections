RSpec.describe Supergroups::Services do
  include SearchApiHelpers

  let(:taxon_id) { "12345" }
  let(:service_supergroup) { Supergroups::Services.new }

  describe "#document_list" do
    it "returns a document list for the services supergroup" do
      allow_any_instance_of(MostPopularContent)
        .to receive(:fetch)
        .and_return(section_tagged_content_list("form", 1))

      expected = [
        {
          link: {
            text: "Tagged Content Title",
            path: "/government/tagged/content",
            description: "Description of tagged content",
            data_attributes: {
              module: "gem-track-click",
              track_category: "servicesDocumentListClicked",
              track_action: 1,
              track_label: "/government/tagged/content",
              track_options: {
                dimension29: "Tagged Content Title",
              },
            },
          },
        },
      ]

      expect(service_supergroup.document_list(taxon_id)).to eq(expected)
    end
  end

  describe "document types" do
    it "returns appropriate things" do
      document_types = GovukDocumentTypes.supergroup_document_types("services")

      expect(document_types).to include("transaction")
    end
  end
end
