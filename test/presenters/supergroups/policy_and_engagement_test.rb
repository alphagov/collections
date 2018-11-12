require 'test_helper'

describe Supergroups::PolicyAndEngagement do
  include RummagerHelpers
  include SupergroupHelpers

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
          consultation_outcome
          closed_consultation
        )

        expected_order = %w(
          closed_consultation
          case_study
        )

        MostRecentContent.any_instance
          .stubs(:fetch)
          .returns(tagged_content(tagged_document_list))

        assert_equal expected_results(expected_order), policy_and_engagement_supergroup.document_list(taxon_id)
      end

      describe '#special_format_count' do
        it 'only include consultations in promoted_content' do
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

          assert_equal 2, policy_and_engagement_supergroup.promoted_content(taxon_id).count
        end

        it 'only include first three consultations in promoted_content' do
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

          assert_equal 3, policy_and_engagement_supergroup.promoted_content(taxon_id).count
        end
      end

      describe '#consultation_closing_date' do
        it 'gets the closing date of past consultations' do
          MostRecentContent.any_instance
            .stubs(:fetch)
            .returns(section_tagged_content_list('open_consultation', 4))

          assert_equal expected_result('open_consultation'), policy_and_engagement_supergroup.document_list(taxon_id)
        end

        it 'gets the closing date of future consultations' do
          rummager_result = section_tagged_content_list('open_consultation', 3)
          rummager_result.push(
            Document.new(
              title: 'Tagged Content Title',
              description: 'Description of tagged content',
              public_updated_at: '2018-02-28T08:01:00.000+00:00',
              base_path: '/government/tagged/content-1',
              content_store_document_type: 'open_consultation',
              organisations: 'Tagged Content Organisation'
            )
          )

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
                path: '/government/tagged/content-1',
                data_attributes: {
                  module: "track-click",
                  track_category: "policyAndEngagementDocumentListClicked",
                  track_action: 1,
                  track_label: '/government/tagged/content-1',
                  track_options: {
                    dimension29: 'Tagged Content Title'
                  }
                }
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

  describe '#promoted_content' do
    before do
      content = content_item_for_base_path('/government/tagged/content').merge(
        "details": {
          "body": "",
          "closing_date": "2017-07-10T23:45:00.000+00:00"
        }
      )

      content_store_has_item('/government/tagged/content', content)
    end

    it 'returns promoted content for the policy and engagment supergroup' do
      MostRecentContent.any_instance
        .stubs(:fetch)
        .returns(section_tagged_content_list('open_consultation'))

      assert_equal expected_result('open_consultation', promoted_content: true), policy_and_engagement_supergroup.promoted_content(taxon_id)
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
      )

      MostRecentContent.any_instance
        .stubs(:fetch)
        .returns(tagged_content(tagged_document_list))

      assert_equal expected_results(expected_order, promoted_content: true), policy_and_engagement_supergroup.promoted_content(taxon_id)
    end
  end

  describe "document types" do
    it "returns appropriate things" do
      document_types = GovukDocumentTypes.supergroup_document_types("policy_and_engagement")

      assert_includes document_types, "open_consultation"
    end
  end

private

  def expected_results(document_types, promoted_content: false)
    results = []
    document_types.each_with_index do |document_type, index|
      results.push(*expected_result(document_type, index, promoted_content: promoted_content))
    end
    results
  end

  def expected_result(document_type, index = 0, promoted_content: false)
    result = {
      link: {
        text: 'Tagged Content Title',
        path: '/government/tagged/content',
        data_attributes: {
          module: "track-click",
          track_category: "policyAndEngagementDocumentListClicked",
          track_action: index + 1,
          track_label: '/government/tagged/content',
          track_options: {
            dimension29: 'Tagged Content Title'
          }
        }
      },
      metadata: {
        public_updated_at: '2018-02-28T08:01:00.000+00:00',
        organisations: 'Tagged Content Organisation',
        document_type: document_type.humanize,
      }
    }

    if promoted_content
      result[:link][:data_attributes][:track_category] = "policyAndEngagementHighlightBoxClicked"
    end

    if consultation?(document_type)
      result[:metadata][:closing_date] = 'Date closed 10 July 2017'
    end

    [result]
  end

  def consultation?(document_type)
    %w[open_consultation consultation_outcome closed_consultation].include?(
      document_type
    )
  end
end
