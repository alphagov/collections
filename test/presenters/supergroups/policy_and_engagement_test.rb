require "test_helper"

describe Supergroups::PolicyAndEngagement do
  include SearchApiHelpers
  include SupergroupHelpers

  let(:taxon_id) { "12345" }
  let(:policy_and_engagement_supergroup) { Supergroups::PolicyAndEngagement.new }

  describe "#document_list" do
    it "returns a document list for the policy and engagment supergroup" do
      MostRecentContent.any_instance
        .stubs(:fetch)
        .returns(section_tagged_content_list("case_study"))

      assert_equal expected_result("case_study"), policy_and_engagement_supergroup.document_list(taxon_id)
    end

    describe "consultations" do
      it "prioritises consultations over other content" do
        tagged_document_list = %w[
          open_consultation
          case_study
          open_consultation
          open_consultation
          open_consultation
        ]

        expected_order = %w[
          open_consultation
          open_consultation
          open_consultation
          open_consultation
          case_study
        ]

        MostRecentContent.any_instance
          .stubs(:fetch)
          .returns(tagged_content(tagged_document_list))

        assert_equal expected_results(expected_order), policy_and_engagement_supergroup.document_list(taxon_id)
      end

      describe "#consultation_closing_date" do
        it "gets the closing date of past consultations" do
          MostRecentContent.any_instance
            .stubs(:fetch)
            .returns(section_tagged_content_list("open_consultation", 4))

          expected = Array.new(4) { |index| expected_result("open_consultation", index).first }
          assert_equal expected, policy_and_engagement_supergroup.document_list(taxon_id)
        end

        it "gets the closing date of future consultations" do
          document = Document.new(
            title: "Tagged Content Title",
            description: "Description of tagged content",
            public_updated_at: "2018-02-28T08:01:00.000+00:00",
            end_date: "2018-07-10T23:45:00.000+00:00",
            base_path: "/government/tagged/content-1",
            content_store_document_type: "open_consultation",
            organisations: "Tagged Content Organisation",
          )

          MostRecentContent.any_instance
            .stubs(:fetch)
            .returns([document])

          expected = [
            {
              link: {
                text: "Tagged Content Title",
                path: "/government/tagged/content-1",
                data_attributes: {
                  module: "gem-track-click",
                  track_category: "policyAndEngagementDocumentListClicked",
                  track_action: 1,
                  track_label: "/government/tagged/content-1",
                  track_options: {
                    dimension29: "Tagged Content Title",
                  },
                },
              },
              metadata: {
                public_updated_at: "2018-02-28T08:01:00.000+00:00",
                organisations: "Tagged Content Organisation",
                document_type: "Open consultation",
                closing_date: "Closing date 10 July 2018",
              },
            },
          ]

          Timecop.freeze("2018-04-18") do
            assert_equal expected, policy_and_engagement_supergroup.document_list(taxon_id)
          end
        end
      end
    end
  end

  describe "document types" do
    it "returns appropriate things" do
      document_types = GovukDocumentTypes.supergroup_document_types("policy_and_engagement")

      assert_includes document_types, "open_consultation"
    end
  end

private

  def expected_results(document_types)
    results = []
    document_types.each_with_index do |document_type, index|
      results.push(*expected_result(document_type, index))
    end
    results
  end

  def expected_result(document_type, index = 0)
    result = {
      link: {
        text: "Tagged Content Title",
        path: "/government/tagged/content",
        data_attributes: {
          module: "gem-track-click",
          track_category: "policyAndEngagementDocumentListClicked",
          track_action: index + 1,
          track_label: "/government/tagged/content",
          track_options: {
            dimension29: "Tagged Content Title",
          },
        },
      },
      metadata: {
        public_updated_at: "2018-02-28T08:01:00.000+00:00",
        organisations: "Tagged Content Organisation",
        document_type: document_type.humanize,
      },
    }

    if consultation?(document_type)
      result[:metadata][:closing_date] = "Date closed 28 August 2018"
    end

    [result]
  end

  def consultation?(document_type)
    %w[open_consultation consultation_outcome closed_consultation].include?(
      document_type,
    )
  end
end
