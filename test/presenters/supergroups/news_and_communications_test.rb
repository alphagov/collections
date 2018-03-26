require 'test_helper'

include RummagerHelpers

describe Supergroups::NewsAndCommunications do
  let(:taxon_id) { '12345' }
  let(:news_and_communications_supergroup) { Supergroups::NewsAndCommunications.new }

  describe '#document_list' do
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
          }
        }
      ]

      assert_equal expected, news_and_communications_supergroup.document_list(taxon_id)
    end
  end
end
