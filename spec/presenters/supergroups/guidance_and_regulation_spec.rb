RSpec.describe Supergroups::GuidanceAndRegulation do
  include SearchApiHelpers

  let(:taxon_id) { "12345" }
  let(:guidance_and_regulation_supergroup) { Supergroups::GuidanceAndRegulation.new }

  describe "#document_list" do
    it "returns a document list for the guidance and regulation supergroup" do
      allow_any_instance_of(MostPopularContent)
        .to receive(:fetch)
        .and_return(section_tagged_content_list("guidance", 1))

      expected = [
        {
          link: {
            text: "Tagged Content Title",
            path: "/government/tagged/content",
            data_attributes: {
              module: "gem-track-click",
              track_category: "guidanceAndRegulationDocumentListClicked",
              track_action: 1,
              track_label: "/government/tagged/content",
              track_options: {
                dimension29: "Tagged Content Title",
              },
            },
          },
          metadata: {
            public_updated_at: "2018-02-28T08:01:00.000+00:00",
            organisations: "Tagged Content Organisation",
            document_type: "Guidance",
          },
        },
      ]

      expect(guidance_and_regulation_supergroup.document_list(taxon_id)).to eq(expected)
    end

    it "return a document list for guides" do
      allow_any_instance_of(MostPopularContent)
        .to receive(:fetch)
        .and_return(section_tagged_content_list("guide", 1))

      expected = [
        {
          link: {
            text: "Tagged Content Title",
            path: "/government/tagged/content",
            description: "Description of tagged content",
            data_attributes: {
              module: "gem-track-click",
              track_category: "guidanceAndRegulationDocumentListClicked",
              track_action: 1,
              track_label: "/government/tagged/content",
              track_options: {
                dimension29: "Tagged Content Title",
              },

            },
          },
          metadata: {
            document_type: "Guide",
          },
        },
      ]

      actual = guidance_and_regulation_supergroup.document_list(taxon_id)

      expect(actual).to eq(expected)
      expect(actual.count).to eq(1)
    end
  end

  describe "document types" do
    it "returns appropriate things" do
      document_types = GovukDocumentTypes.supergroup_document_types("guidance_and_regulation")

      expect(document_types).to include("guidance")
    end
  end
end
