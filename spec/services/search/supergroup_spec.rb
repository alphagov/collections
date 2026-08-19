describe Search::Supergroup do
  include SearchApiHelpers

  let(:news_and_comms_supergroup) { described_class.new(organisation_slug: "attorney-generals-office", content_purpose_supergroup: "news_and_communications") }
  let(:services_supergroup) { described_class.new(organisation_slug: "attorney-generals-office", content_purpose_supergroup: "services") }
  let(:guidance_and_regulation_supergroup) { described_class.new(organisation_slug: "attorney-generals-office", content_purpose_supergroup: "guidance_and_regulation") }

  let(:cache) { ActiveSupport::Cache::MemoryStore.new }

  before do
    stub_news_and_comms_supergroup_request
    stub_services_supergroup_request_to_return_no_docs
    stub_guidance_and_regulation_supergroup_request

    allow(Rails).to receive(:cache).and_return(cache)
  end

  describe "#has_documents?" do
    it "returns false if there are no docs" do
      expect(services_supergroup.has_documents?).to eq(false)
    end

    it "returns true if there are docs" do
      expect(news_and_comms_supergroup.has_documents?).to eq(true)
    end
  end

  describe "#documents" do
    it "provides a set of raw search_api search results" do
      expect([raw_search_api_result("news_story")]).to eq(news_and_comms_supergroup.documents)
    end

    it "provides a set of raw search_api search results even if the set is empty" do
      expect([]).to eq(services_supergroup.documents)
    end

    context "when requesting search results sorted by public_timestamp" do
      let(:search_params) do
        { count: 2,
          fields: %w[title link content_store_document_type public_timestamp],
          filter_content_purpose_supergroup: "news_and_communications",
          filter_organisations: "attorney-generals-office",
          order: "-public_timestamp",
          reject_content_purpose_subgroup: %w[decisions updates_and_alerts] }
      end

      let(:supergroup_documents) { news_and_comms_supergroup.documents }

      it_behaves_like "a cached Search API request for supergroup documents", expected_expiry: 60.minutes
    end

    context "when fetching documents sorted by -popularity" do
      let(:search_params) do
        { count: 2,
          fields: %w[title link content_store_document_type public_timestamp],
          filter_content_purpose_supergroup: "guidance_and_regulation",
          filter_organisations: "attorney-generals-office",
          order: "-popularity" }
      end

      let(:supergroup_documents) { guidance_and_regulation_supergroup.documents }

      it_behaves_like "a cached Search API request for supergroup documents", expected_expiry: 12.hours
    end
  end

  def stub_services_supergroup_request_to_return_no_docs
    stub_supergroup_request(
      results: [],
      additional_params: {
        filter_organisations: "attorney-generals-office",
        filter_content_purpose_supergroup: "services",
        order: "-popularity",
      },
    )
  end

  def stub_news_and_comms_supergroup_request
    stub_supergroup_request(
      results: [raw_search_api_result("news_story")],
      additional_params: {
        filter_content_purpose_supergroup: "news_and_communications",
        filter_organisations: "attorney-generals-office",
      },
    )
  end

  def stub_guidance_and_regulation_supergroup_request
    stub_supergroup_request(
      results: [raw_search_api_result("guide")],
      additional_params: {
        filter_organisations: "attorney-generals-office",
        filter_content_purpose_supergroup: "guidance_and_regulation",
        order: "-popularity",
      },
    )
  end

  def raw_search_api_result(doc_type)
    {
      "title" => "Quiddich World Cup 2022 begins",
      "link" => "/government/news/its-coming-home",
      "content_store_document_type" => doc_type,
      "public_timestamp " => "2022-11-21T12:00:00.000+01:00",
    }
  end
end
