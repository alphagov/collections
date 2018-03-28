require 'test_helper'

include RummagerHelpers

describe Supergroups::PolicyAndEngagement do
  let(:taxon_id) { '12345' }
  let(:policy_and_engagement_supergroup) { Supergroups::PolicyAndEngagement.new }

  describe '#document_list' do
    it 'returns a document list for the policy and engagment supergroup' do
      MostRecentContent.any_instance
        .stubs(:fetch)
        .returns(section_tagged_content_list('case_study'))

      expected = [
        {
          link: {
            text: 'Tagged Content Title',
            path: '/government/tagged/content'
          },
          metadata: {
            public_updated_at: '2018-02-28T08:01:00.000+00:00',
            organisations: 'Tagged Content Organisation',
            document_type: 'Case study'
          }
        }
      ]

      assert_equal expected, policy_and_engagement_supergroup.document_list(taxon_id)
    end
  end
end
