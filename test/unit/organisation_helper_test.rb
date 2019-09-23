require "test_helper"

describe OrganisationHelper do
  include OrganisationHelpers
  include RummagerHelpers
  describe "#organisation_type_name" do
    it "returns a human-readable name given an organisation_type" do
      assert_equal "Executive non-departmental public body", organisation_type_name("executive_ndpb")
    end

    it "returns 'other' for an unrecognised organisation_type" do
      assert_equal "Other", organisation_type_name("something_else")
    end
  end

  describe "#search_results_to_documents" do
    let(:organisation) {
      content_item = ContentItem.new(organisation_with_featured_documents)
      Organisation.new(content_item)
    }

    let(:search_results) {
      [
        {
          "title" => "demo",
          "link" => "/demo",
          "content_store_document_type": "Foi",
          "public_timestamp": "2019-01-03T04:05:06+07:00",
        },
      ]
    }

    let(:result) {
      search_results_to_documents(search_results, organisation)
    }

    let(:expected) {
      {
        link: {
          text: "demo",
          path: "/demo",
        },
        metadata: {
          public_updated_at: nil,
          document_type: nil,
        },
      }
    }

    it "provides an expected document format" do
      assert_equal result[:brand], "attorney-generals-office"
      assert_equal expected, result[:items].first
    end
  end
end
