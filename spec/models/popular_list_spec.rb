RSpec.describe PopularListSet do
  include SearchApiHelpers

  describe "#formatted_results" do
    let(:top_level_browse_page) { GovukSchemas::Example.find("mainstream_browse_page", example_name: "top_level_page") }
    let(:content_item) { ContentItem.new(top_level_browse_page) }
    let(:popular_list) { described_class.new(content_item) }

    it "formats the response from SearchAPI" do
      content_ids = content_item
                    .linked_items("second_level_browse_pages")
                    .map { |content_item| content_item.content_item_data["content_id"] }

      params = {
        filter_any_mainstream_browse_page_content_ids: webmock_match_array(content_ids),
        count: "3",
        order: "-popularity",
        fields: webmock_match_array(SearchApiFields::POPULAR_BROWSE_SEARCH_FIELDS),
      }

      search_response = {
        "results" => [
          search_api_document_for_browse("tagged-to-a-benefits-topic"),
          search_api_document_for_browse("tagged-to-another-benefits-topic"),
        ],
      }

      expected_results = [
        {
          title: "Tagged to a benefits topic",
          link: "/tagged-to-a-benefits-topic",
        },
        {
          title: "Tagged to another benefits topic",
          link: "/tagged-to-another-benefits-topic",
        },
      ]

      stub_search(params:, body: search_response)
      expect(popular_list.formatted_results).to eq expected_results
    end
  end
end
