RSpec.describe MostRecentContent do
  include SearchApiFields
  include SearchApiHelpers

  let(:document_types) { %w[authored_article correspondence] }
  let(:taxon_content_id) { "a18d16c4-29ff-41c2-a667-022f7615ba49" }
  let(:most_recent_content) do
    MostRecentContent.new(
      content_id: taxon_content_id,
      filter_content_store_document_type: document_types,
    )
  end

  describe "#fetch" do
    it "returns the results from search" do
      search_results = {
        "results" => [
          { "title" => "First news story" },
          { "title" => "Second news story" },
          { "title" => "Third news story" },
          { "title" => "Fourth news story" },
          { "title" => "Fifth news story" },
        ],
      }

      params = {
        start: "0",
        count: "5",
        fields: webmock_match_array(SearchApiFields::TAXON_SEARCH_FIELDS),
        order: "-public_timestamp",
        filter_part_of_taxonomy_tree: [taxon_content_id],
        filter_content_store_document_type: document_types,
      }

      stub_search(params:, body: search_results)

      results = most_recent_content.fetch
      expect(5).to eq(results.count)
    end
  end
end
