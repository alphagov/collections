RSpec.describe MostPopularContent do
  include SearchApiFields
  include SearchApiHelpers

  let(:document_types) { %w[detailed_guide guidance] }
  let(:taxon_content_id) { "c3c860fc-a271-4114-b512-1c48c0f82564" }
  let(:most_popular_content) do
    MostPopularContent.new(
      content_id: taxon_content_id,
      filter_content_store_document_type: document_types,
    )
  end

  describe "#fetch" do
    it "searches using the expected parameters" do
      search_results = {
        "results" => [
          { "title" => "Doc 1" },
          { "title" => "A Doc 2" },
        ],
      }

      params = {
        start: "0",
        count: "5",
        fields: webmock_match_array(SearchApiFields::TAXON_SEARCH_FIELDS),
        order: "-popularity",
        filter_part_of_taxonomy_tree: [taxon_content_id],
        filter_content_store_document_type: document_types,
      }

      stub_search(params: params, body: search_results)

      results = most_popular_content.fetch
      expect(2).to eq(results.count)
    end
  end
end
