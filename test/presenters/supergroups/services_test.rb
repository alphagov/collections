require "test_helper"

describe Supergroups::Services do
  include SearchApiHelpers

  let(:taxon_id) { "12345" }
  let(:service_supergroup) { Supergroups::Services.new }

  describe "#document_list" do
    it "returns a document list for the services supergroup" do
      MostPopularContent.any_instance
        .stubs(:fetch)
        .returns(section_tagged_content_list("form", 1))

      expected = [
        {
          link: {
            text: "Tagged Content Title",
            path: "/government/tagged/content",
            description: "Description of tagged content",
            data_attributes: {
              module: "track-click",
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

      assert_equal expected, service_supergroup.document_list(taxon_id)
    end
  end

  describe "document types" do
    it "returns appropriate things" do
      document_types = GovukDocumentTypes.supergroup_document_types("services")

      assert_includes document_types, "transaction"
    end
  end
end
