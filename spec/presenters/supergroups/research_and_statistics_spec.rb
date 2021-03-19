require "test_helper"

describe Supergroups::ResearchAndStatistics do
  include SearchApiHelpers

  let(:taxon_id) { "12345" }
  let(:research_and_statistics_supergroup) { Supergroups::ResearchAndStatistics.new }

  describe "#document_list" do
    it "returns a document list for the research_and_statistics supergroup" do
      MostRecentContent.any_instance
        .stubs(:fetch)
        .returns(section_tagged_content_list("statistics"))

      expected = [
        {
          link: {
            text: "Tagged Content Title",
            path: "/government/tagged/content",
            data_attributes: {
              module: "gem-track-click",
              track_category: "researchAndStatisticsDocumentListClicked",
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

      assert_equal expected, research_and_statistics_supergroup.document_list(taxon_id)
    end
  end

  describe "document types" do
    it "returns appropriate things" do
      document_types = GovukDocumentTypes.supergroup_document_types("research_and_statistics")

      assert_includes document_types, "statistics"
    end
  end
end
