RSpec.describe Supergroups::PolicyAndEngagement do
  include SearchApiHelpers
  include SupergroupHelpers

  let(:taxon_id) { "12345" }
  let(:policy_and_engagement_supergroup) { Supergroups::PolicyAndEngagement.new }

  describe "#document_list" do
    it "returns a document list for the policy and engagment supergroup" do
      allow_any_instance_of(MostRecentContent)
        .to receive(:fetch)
        .and_return(section_tagged_content_list("case_study"))

      expect(policy_and_engagement_supergroup.document_list(taxon_id)).to eq(expected_result("case_study"))
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

        allow_any_instance_of(MostRecentContent)
          .to receive(:fetch)
          .and_return(tagged_content(tagged_document_list))

        expect(policy_and_engagement_supergroup.document_list(taxon_id)).to eq(expected_results(expected_order))
      end

      describe "#consultation_closing_date" do
        it "gets the closing date of past consultations" do
          allow_any_instance_of(MostRecentContent)
            .to receive(:fetch)
            .and_return(section_tagged_content_list("open_consultation", 4))

          expected = Array.new(4) { |index| expected_result("open_consultation", index).first }
          expect(policy_and_engagement_supergroup.document_list(taxon_id)).to eq(expected)
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

          allow_any_instance_of(MostRecentContent)
            .to receive(:fetch)
            .and_return([document])

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
            expect(policy_and_engagement_supergroup.document_list(taxon_id)).to eq(expected)
          end
        end
      end
    end
  end

  describe "document types" do
    it "returns appropriate things" do
      document_types = GovukDocumentTypes.supergroup_document_types("policy_and_engagement")

      expect(document_types).to include("open_consultation")
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
