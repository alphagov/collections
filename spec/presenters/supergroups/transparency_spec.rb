RSpec.describe Supergroups::Transparency do
  include SearchApiHelpers

  let(:taxon_id) { "12345" }
  let(:transparency_supergroup) { Supergroups::Transparency.new }

  describe "#document_list" do
    it "returns a document list for the transparency supergroup" do
      allow_any_instance_of(MostRecentContent)
        .to receive(:fetch)
        .and_return(section_tagged_content_list("statistics"))

      expected = [
        {
          link: {
            text: "Tagged Content Title",
            path: "/government/tagged/content",
            data_attributes: {
              module: "gem-track-click",
              track_category: "transparencyDocumentListClicked",
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
            document_type: "Statistics",
          },
        },
      ]

      expect(transparency_supergroup.document_list(taxon_id)).to eq(expected)
    end
  end

  describe "document types" do
    it "returns appropriate things" do
      document_types = GovukDocumentTypes.supergroup_document_types("transparency")

      expect(document_types).to include("transparency")
    end
  end
end
