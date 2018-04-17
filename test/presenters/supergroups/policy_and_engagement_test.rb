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
            path: '/government/tagged/content',
            featured: true
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

    describe 'consultations' do
      before do
        content = content_item_for_base_path('/government/tagged/content').merge(
          "details": {
            "body": "",
            "closing_date": "2018-07-10T23:45:00.000+00:00"
          }
        )

        content_store_has_item('/government/tagged/content', content)
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
              path: '/government/tagged/content',
              featured: true
            },
            metadata: {
              public_updated_at: '2018-02-28T08:01:00.000+00:00',
              organisations: 'Tagged Content Organisation',
              document_type: 'Consultation outcome',
              closing_date: '10 July 2018'
            }
          },
          {
            link: {
              text: 'Tagged Content Title',
              path: '/government/tagged/content',
              featured: true
            },
            metadata: {
              public_updated_at: '2018-02-28T08:01:00.000+00:00',
              organisations: 'Tagged Content Organisation',
              document_type: 'Open consultation',
              closing_date: '10 July 2018'
            }
          },
          {
            link: {
              text: 'Tagged Content Title',
              path: '/government/tagged/content',
              featured: true
            },
            metadata: {
              public_updated_at: '2018-02-28T08:01:00.000+00:00',
              organisations: 'Tagged Content Organisation',
              document_type: 'Closed consultation',
              closing_date: '10 July 2018'
            }
          },
          {
            link: {
              text: 'Tagged Content Title',
              path: '/government/tagged/content',
              featured: true
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
              path: '/government/tagged/content',
              featured: true
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

      it 'gets the closing date of consultations' do
        MostRecentContent.any_instance
          .stubs(:fetch)
          .returns(section_tagged_content_list('open_consultation'))

        expected = [
          {
            link: {
              text: 'Tagged Content Title',
              path: '/government/tagged/content',
              featured: true
            },
            metadata: {
              public_updated_at: '2018-02-28T08:01:00.000+00:00',
              organisations: 'Tagged Content Organisation',
              document_type: 'Open consultation',
              closing_date: '10 July 2018'
            }
          }
        ]

        assert_equal expected, policy_and_engagement_supergroup.document_list(taxon_id)
      end
    end
  end
end
