require "test_helper"

describe Search::Supergroup do
  include SearchApiHelpers

  before :each do
    @supergroup = described_class.new(organisation_slug: "attorney-generals-office", content_purpose_supergroup: "news_and_communications")
    @no_docs_supergroup = described_class.new(organisation_slug: "attorney-generals-office", content_purpose_supergroup: "services")

    stub_services_supergroup_request
    stub_news_and_comms_supergroup_request
  end

  describe "#has_documents?" do
    it "returns false if there are no docs" do
      assert_equal false, @no_docs_supergroup.has_documents?
    end

    it "returns true if there are docs" do
      assert_equal true, @supergroup.has_documents?
    end
  end

  describe "#documents" do
    it "provides a set of raw rummager search results" do
      assert_equal @supergroup.documents, [raw_rummager_result]
    end

    it "provides a set of raw rummager search results even if the set is empty" do
      assert_equal @no_docs_supergroup.documents, []
    end
  end

  def stub_services_supergroup_request
    stub_supergroup_request(
      results: [],
      additional_params: {
        filter_organisations: "attorney-generals-office",
        filter_content_purpose_supergroup: "services",
      },
    )
  end

  def raw_rummager_result
    {
      "title" => "Quiddich World Cup 2022 begins",
      "link" => "/government/news/its-coming-home",
      "content_store_document_type" => "news_story",
      "public_timestamp " => "2022-11-21T12:00:00.000+01:00",
    }
  end

  def stub_news_and_comms_supergroup_request
    stub_supergroup_request(
      results: [raw_rummager_result],
      additional_params: {
        filter_content_purpose_supergroup: "news_and_communications",
        filter_organisations: "attorney-generals-office",
      },
    )
  end
end
