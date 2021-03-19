RSpec.describe TaggedContent do
  include SearchApiHelpers

  describe "#fetch" do
    let(:taxon_content_id) { "c3c860fc-a271-4114-b512-1c48c0f82564" }
    let(:tagged_content) { described_class.new(taxon_content_id) }

    it "returns the results from search" do
      search_results = {
        "results" => [{
          "title" => "Doc 1",
        }],
      }

      params = {
        start: "0",
        count: SearchApiSearch::PAGE_SIZE_TO_GET_EVERYTHING.to_s,
        fields: webmock_match_array(%w[title description link content_store_document_type]),
        filter_taxons: [taxon_content_id],
        order: "title",
      }

      stub_search(params: params, body: search_results)

      results = tagged_content.fetch
      expect(1).to eq(results.count)
      expect("Doc 1").to eq(results.first.title)
    end
  end
end
