RSpec.describe SearchDocuments do
  include SearchApiHelpers

  context "for topical events" do
    describe "#fetch_related_documents_with_format" do
      before do
        @slug = "/some/slug"
        @documents_service = SearchDocuments.new(@slug, "filter_topical_events")
      end

      it "makes the correct call to search api" do
        search_format = { some_format: "news_article" }
        expected_search_params = search_format.merge(filter_topical_events: [@slug])

        expect(Services.search_api)
          .to receive(:search)
          .with(hash_including(expected_search_params))
          .and_return({ "results" => [] })

        @documents_service.fetch_related_documents_with_format(search_format)
      end

      it "returns correctly formatted information about related documents" do
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

        expect(@documents_service.fetch_related_documents_with_format({ filter_format: "news_article" })).to eq [
          {
            link: {
              text: "Policy on Topicals",
              path: "/foo/policy_paper",
            },
            metadata: {
              public_updated_at: Time.zone.parse("2016-10-07T22:18:32Z"),
              document_type: "News article",
            },
          },
          {
            link: {
              text: "PM attends summit on topical events",
              path: "/foo/news_story",
            },
            metadata: {
              public_updated_at: Time.zone.parse("2018-10-07T22:18:32Z"),
              document_type: "News article",
            },
          },
        ]
      end
    end
  end
end
