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

    it 'prioritises consultations over other content' do
      tagged_content = []
      tagged_content.push(*section_tagged_content_list('consultation_outcome'))
      tagged_content.push(*section_tagged_content_list('case_study'))
      tagged_content.push(*section_tagged_content_list('open_consultation'))
      tagged_content.push(*section_tagged_content_list('case_study'))
      tagged_content.push(*section_tagged_content_list('closed_consultation'))

      MostRecentContent.any_instance
        .stubs(:fetch)
        .returns(tagged_content)

      expected = [
        {
          link: {
            text: 'Tagged Content Title',
            path: '/government/tagged/content'
          },
          metadata: {
            public_updated_at: '2018-02-28T08:01:00.000+00:00',
            organisations: 'Tagged Content Organisation',
            document_type: 'Consultation outcome'
          }
        },
        {
          link: {
            text: 'Tagged Content Title',
            path: '/government/tagged/content'
          },
          metadata: {
            public_updated_at: '2018-02-28T08:01:00.000+00:00',
            organisations: 'Tagged Content Organisation',
            document_type: 'Open consultation'
          }
        },
        {
          link: {
            text: 'Tagged Content Title',
            path: '/government/tagged/content'
          },
          metadata: {
            public_updated_at: '2018-02-28T08:01:00.000+00:00',
            organisations: 'Tagged Content Organisation',
            document_type: 'Closed consultation'
          }
        },
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
        },
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

    it 'only show applies special formatting to consultations' do
      tagged_content = []
      tagged_content.push(*section_tagged_content_list('case_study'))
      tagged_content.push(*section_tagged_content_list('case_study'))
      tagged_content.push(*section_tagged_content_list('case_study'))
      tagged_content.push(*section_tagged_content_list('consultation_outcome'))
      tagged_content.push(*section_tagged_content_list('closed_consultation'))

      MostRecentContent.any_instance
        .stubs(:fetch)
        .returns(tagged_content)

      assert_equal 2, policy_and_engagement_supergroup.special_format_count(taxon_id)
    end

    it 'only show applies special formatting to the first three consultations' do
      tagged_content = []
      tagged_content.push(*section_tagged_content_list('consultation_outcome'))
      tagged_content.push(*section_tagged_content_list('closed_consultation'))
      tagged_content.push(*section_tagged_content_list('open_consultation'))
      tagged_content.push(*section_tagged_content_list('consultation_outcome'))
      tagged_content.push(*section_tagged_content_list('closed_consultation'))

      MostRecentContent.any_instance
        .stubs(:fetch)
        .returns(tagged_content)

      assert_equal 3, policy_and_engagement_supergroup.special_format_count(taxon_id)
    end
  end
end
