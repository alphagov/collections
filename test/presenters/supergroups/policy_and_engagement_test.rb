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

      assert_equal expected_result('case_study'), policy_and_engagement_supergroup.document_list(taxon_id)
    end

    describe 'consultations' do
      before do
        content = content_item_for_base_path('/government/tagged/content').merge(
          "details": {
            "body": "",
            "closing_date": "2017-07-10T23:45:00.000+00:00"
          }
        )

        content_store_has_item('/government/tagged/content', content)
      end

      it 'prioritises consultations over other content' do
        tagged_document_list = %w(
          consultation_outcome
          case_study
          open_consultation
          case_study
          closed_consultation
        )

        expected_order = %w(
          consultation_outcome
          open_consultation
          closed_consultation
          case_study
          case_study
        )

        MostRecentContent.any_instance
          .stubs(:fetch)
          .returns(tagged_content(tagged_document_list))

        assert_equal expected_results(expected_order), policy_and_engagement_supergroup.document_list(taxon_id)
      end

      describe '#special_format_count' do
        it 'only include consultations in promoted_content_count' do
          tagged_document_list = %w(
            case_study
            case_study
            case_study
            consultation_outcome
            closed_consultation
          )

          MostRecentContent.any_instance
            .stubs(:fetch)
            .returns(tagged_content(tagged_document_list))

          assert_equal 2, policy_and_engagement_supergroup.promoted_content_count(taxon_id)
        end

        it 'only include first three consultations in promoted_content_count' do
          tagged_document_list = %w(
            consultation_outcome
            closed_consultation
            open_consultation
            consultation_outcome
            closed_consultation
          )

          MostRecentContent.any_instance
            .stubs(:fetch)
            .returns(tagged_content(tagged_document_list))

          assert_equal 3, policy_and_engagement_supergroup.promoted_content_count(taxon_id)
        end
      end

      describe '#consultation_closing_date' do
        it 'gets the closing date of past consultations' do
          MostRecentContent.any_instance
            .stubs(:fetch)
            .returns(section_tagged_content_list('open_consultation'))

          assert_equal expected_result('open_consultation'), policy_and_engagement_supergroup.document_list(taxon_id)
        end

        it 'gets the closing date of future consultations' do
          rummager_result = [
            Document.new(
              title: 'Tagged Content Title',
              description: 'Description of tagged content',
              public_updated_at: '2018-02-28T08:01:00.000+00:00',
              base_path: '/government/tagged/content-1',
              content_store_document_type: 'open_consultation',
              organisations: 'Tagged Content Organisation'
            )
          ]

          MostRecentContent.any_instance
            .stubs(:fetch)
            .returns(rummager_result)

          content = content_item_for_base_path('/government/tagged/content-1').merge(
            "details": {
              "body": "",
              "closing_date": "2018-07-10T23:45:00.000+00:00"
            }
          )

          content_store_has_item('/government/tagged/content-1', content)

          expected = [
            {
              link: {
                text: 'Tagged Content Title',
                path: '/government/tagged/content-1'
              },
              metadata: {
                public_updated_at: '2018-02-28T08:01:00.000+00:00',
                organisations: 'Tagged Content Organisation',
                document_type: 'Open consultation',
                closing_date: 'Closing date 10 July 2018'
              }
            }
          ]

          Timecop.freeze("2018-04-18") do
            assert_equal expected, policy_and_engagement_supergroup.document_list(taxon_id)
          end
        end
      end
    end
  end

  def tagged_content(document_types)
    content_list = []
    document_types.each do |document_type|
      content_list.push(*section_tagged_content_list(document_type))
    end
    content_list
  end

  def expected_results(document_types)
    results = []
    document_types.each do |document_type|
      results.push(*expected_result(document_type))
    end
    results
  end

  def expected_result(document_type)
    result = {
      link: {
        text: 'Tagged Content Title',
        path: '/government/tagged/content'
      },
      metadata: {
        public_updated_at: '2018-02-28T08:01:00.000+00:00',
        organisations: 'Tagged Content Organisation',
        document_type: document_type.humanize,
      }
    }

    if consultation?(document_type)
      result[:metadata][:closing_date] = 'Date closed 10 July 2017'
    end

    [result]
  end

  def consultation?(document_type)
    document_type == 'open_consultation' ||
      document_type == 'consultation_outcome' ||
      document_type == 'closed_consultation'
  end
end
