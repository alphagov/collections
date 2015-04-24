require 'test_helper'

describe RelatedTopicList do
  include ContentSchemaHelpers

  describe "#related_topics_for" do
    it "returns related topics for a subsection" do
      content_store = content_store_with_response(content_schema_example(:mainstream_browse_page, :level_2_page_with_related_topics))

      topic_list = RelatedTopicList.new(content_store, nil)
      found_topic = topic_list.related_topics_for('/browse/whatever').first

      assert_equal found_topic.title, 'Universal credit'
      assert_equal found_topic.web_url, 'https://www.gov.uk/benefits/universal-credit'
    end

    it "returns guidance categories from whitehall when there are no related topics" do
      content_store = content_store_with_response(content_schema_example(:mainstream_browse_page, :level_2_page))
      whitehall = whitehall_with_response([{title: 'From Whitehall', content_with_tag: { web_url: 'http://example.org/whatever'}}])

      topic_list = RelatedTopicList.new(content_store, whitehall)

      assert_equal topic_list.related_topics_for('/browse/whatever'),
        [OpenStruct.new(title: 'From Whitehall', web_url: 'http://example.org/whatever')]
    end

    it "handles missing links" do
      content_store = content_store_with_response({})
      whitehall = whitehall_with_response([{title: 'From Whitehall', content_with_tag: { web_url: 'http://example.org/whatever' }}])

      topic_list = RelatedTopicList.new(content_store, whitehall)

      assert_equal topic_list.related_topics_for('/browse/whatever'),
        [OpenStruct.new(title: 'From Whitehall', web_url: 'http://example.org/whatever')]
    end

    it "returns an empty array when content-store returns 404" do
      content_store = stub()
      content_store.expects(:content_item).with('/browse/whatever').raises(GdsApi::HTTPNotFound, 'A message')

      topic_list = RelatedTopicList.new(content_store, nil)

      assert_equal topic_list.related_topics_for('/browse/whatever'), []
    end

    it "returns an empty array when content-store returns archived" do
      content_store = stub()
      content_store.expects(:content_item).with('/browse/whatever').raises(GdsApi::HTTPGone, 'A message')

      topic_list = RelatedTopicList.new(content_store, nil)

      assert_equal topic_list.related_topics_for('/browse/whatever'), []
    end

    it "sorts the output by title" do
      content_store = content_store_with_response(links: { related_topics: [
          { title: 'B' },
          { title: 'A' },
          { title: 'C' }
      ]})

      topic_list = RelatedTopicList.new(content_store, nil)

      assert_equal topic_list.related_topics_for('/browse/whatever').map(&:title), %w[A B C]
    end

    def content_store_with_response(results)
      mock("content_store", content_item: build_ostruct_recursively(results))
    end

    def whitehall_with_response(results)
      mock("whitehall", sub_sections: build_ostruct_recursively(results: results))
    end
  end
end
