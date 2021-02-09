require "test_helper"

describe OrganisationHelper do
  include OrganisationHelpers
  include SearchApiHelpers
  describe "#organisation_type_name" do
    it "returns a human-readable name given an organisation_type" do
      assert_equal "Executive non-departmental public body", organisation_type_name("executive_ndpb")
    end

    it "returns 'other' for an unrecognised organisation_type" do
      assert_equal "Other", organisation_type_name("something_else")
    end
  end

  describe "#search_results_to_documents" do
    let(:organisation) do
      content_item = ContentItem.new(organisation_with_featured_documents)
      Organisation.new(content_item)
    end

    let(:search_results) do
      [
        {
          "title" => "demo",
          "link" => "/demo",
          "content_store_document_type": "Foi",
          "public_timestamp": "2019-01-03T04:05:06+07:00",
        },
      ]
    end

    let(:result) do
      search_results_to_documents(search_results, organisation)
    end

    let(:expected) do
      {
        link: {
          text: "demo",
          path: "/demo",
          locale: "en",
        },
        metadata: {
          public_updated_at: nil,
          document_type: nil,
          locale: {
            public_updated_at: false,
            document_type: :en,
          },
        },
      }
    end

    it "provides an expected document format" do
      assert_equal result[:brand], "attorney-generals-office"
      assert_equal expected, result[:items].first
    end
  end
end
