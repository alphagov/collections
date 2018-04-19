require 'test_helper'

include RummagerHelpers, SupergroupHelpers

describe Supergroups::NewsAndCommunications do
  let(:taxon_id) { '12345' }
  let(:news_and_communications_supergroup) { Supergroups::NewsAndCommunications.new }

  describe '#document_list' do
    before do
      content = content_item_for_base_path('/government/tagged/content').merge(
        "details": {
          "image": {
            "url": "an/image/path",
            "alt_text": "some alt text"
          }
        }
      )

      content_store_has_item('/government/tagged/content', content)
    end

    it 'returns a document list for the news and communications supergroup' do
      MostRecentContent.any_instance
        .stubs(:fetch)
        .returns(section_tagged_content_list('news_story'))

      expected = [
        {
          link: {
            text: 'Tagged Content Title',
            path: '/government/tagged/content'
          },
          metadata: {
            public_updated_at: '2018-02-28T08:01:00.000+00:00',
            organisations: 'Tagged Content Organisation',
            document_type: 'News story'
          },
          image: {
            url: 'an/image/path',
            alt: 'some alt text'
          }
        }
      ]

      assert_equal expected, news_and_communications_supergroup.document_list(taxon_id)
    end

    it 'returns an image for the first news item only' do
      tagged_document_list = %w(news_story correspondance press_release)

      MostRecentContent.any_instance
        .stubs(:fetch)
        .returns(tagged_content(tagged_document_list))

      news_and_communications_supergroup.document_list(taxon_id).each_with_index do |content_item, i|
        if i.eql?(0)
          assert content_item.key?(:image)
        else
          refute content_item.key?(:image)
        end
      end
    end
  end
end
