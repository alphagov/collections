RSpec.describe SearchDocuments::PopularBrowseSearchDocuments do
  include SearchApiHelpers

  describe "#fetch_related_documents_with_format" do
    before do
      @slug_array = %w[childcare-parenting benefits]
      @documents_service = SearchDocuments::PopularBrowseSearchDocuments.new(@slug_array)
    end

    it "makes the correct call to search api" do
      expected_search_params = {
        filter_any_mainstream_browse_pages: @slug_array,
        count: 3,
        order: "-popularity",
        fields: SearchApiFields::POPULAR_BROWSE_SEARCH_FIELDS,
      }

      expect(Services.search_api)
        .to receive(:search)
        .with(hash_including(expected_search_params))
        .and_return({ "results" => [] })

      @documents_service.fetch_related_documents_with_format
    end

    it "formats the response from SearchAPI" do
      search_api_response = {
        'results': [
          {
            'link': "/foo/policy_paper",
            'title': "Policy on Topicals",
            'public_timestamp': "2016-10-07T22:18:32Z",
            'display_type': "news_article",
          },
          {
            'link': "/foo/news_story",
            'title': "PM attends summit on topical events",
            'public_timestamp': "2018-10-07T22:18:32Z",
            'content_store_document_type': "news_article",
          },
        ],
      }

      stub_search(body: search_api_response)

      expect(@documents_service.fetch_related_documents_with_format).to eq(
        [
          {
            title: "Policy on Topicals",
            link: "/foo/policy_paper",
          },
          {
            title: "PM attends summit on topical events",
            link: "/foo/news_story",
          },
        ],
      )
    end
  end
end
