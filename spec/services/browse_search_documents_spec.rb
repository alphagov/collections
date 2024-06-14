RSpec.describe BrowseSearchDocuments do
  include SearchApiHelpers

  describe "#fetch_related_documents_with_format" do
    let(:second_level_browse_page_slugs) { ["benefits/looking-for-work", "benefits/unable-to-work"] }
    let(:documents_service) { described_class.new(second_level_browse_page_slugs) }
    let(:search_params) do
      {
        filter_any_mainstream_browse_pages: second_level_browse_page_slugs,
        count: 3,
        order: "-popularity",
        fields: SearchApiFields::POPULAR_BROWSE_SEARCH_FIELDS,
      }
    end
    let(:search_response) do
      {
        "results" => [
          search_api_document_for_browse("tagged-to-a-benefits-topic"),
          search_api_document_for_browse("tagged-to-another-benefits-topic"),
        ],
      }
    end

    it "makes the correct call to search api" do
      expect(Services)
        .to receive(:cached_search)
        .with(hash_including(search_params))
        .and_return(search_response)

      documents_service.fetch_related_documents_with_format
    end

    it "formats the response from SearchAPI" do
      allow(Services)
        .to receive(:cached_search)
        .with(hash_including(search_params))
        .and_return(search_response)

      expected_results = [
        {
          title: "tagged to a benefits topic",
          link: "/tagged-to-a-benefits-topic",
        },
        {
          title: "tagged to another benefits topic",
          link: "/tagged-to-another-benefits-topic",
        },
      ]

      formatted_results = documents_service.fetch_related_documents_with_format
      expect(formatted_results).to eq expected_results
    end
  end
end
