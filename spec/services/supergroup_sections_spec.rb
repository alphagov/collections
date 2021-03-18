RSpec.describe SupergroupSections::Sections do
  include SearchApiHelpers
  include TaxonHelpers

  let(:taxon_id) { "12345" }
  let(:base_path) { "/base/path" }
  let(:supergroup_sections) { SupergroupSections::Sections.new(taxon_id, base_path) }
  let(:sections) { supergroup_sections.sections }

  describe "#sections" do
    before do
      stub_config = {
        Supergroups::PolicyAndEngagement => section_tagged_content_list("case_study"),
        Supergroups::Services => section_tagged_content_list("form"),
        Supergroups::GuidanceAndRegulation => section_tagged_content_list("guide"),
        Supergroups::NewsAndCommunications => [],
        Supergroups::Transparency => [],
        Supergroups::ResearchAndStatistics => [],
      }

      stub_config.each do |klass, results|
        allow_any_instance_of(klass)
          .to receive(:tagged_content)
          .with(taxon_id)
          .and_return(results)
      end
    end

    it "returns a list of supergroup sections" do
      expect(sections.length).to be 6
    end

    it "returns a list of supergroup details" do
      section_details = %i[
        id
        title
        promoted_content
        documents
        documents_with_promoted
        partial_template
        see_more_link
        show_section
      ]

      sections.each do |section|
        expect(section.keys).to eq(section_details)
      end
    end

    it "each section has an id" do
      expected_ids = %w[
        services
        guidance_and_regulation
        news_and_communications
        policy_and_engagement
        transparency
        research_and_statistics
      ]

      section_ids = sections.map { |section| section[:id] }

      expect(section_ids).to match_array(expected_ids)
    end

    it "knows if each sections should be shown or not" do
      shown_sections = sections.select { |section| section[:show_section] == true }
      not_show_sections = sections.select { |section| section[:show_section] == false }

      expect(shown_sections.length).to be 3
      expect(not_show_sections.length).to be 3
    end
  end
end
