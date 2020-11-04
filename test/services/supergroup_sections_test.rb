require "test_helper"

describe SupergroupSections::Sections do
  include RummagerHelpers
  include TaxonHelpers

  let(:taxon_id) { "12345" }
  let(:base_path) { "/base/path" }
  let(:supergroup_sections) { SupergroupSections::Sections.new(taxon_id, base_path) }

  describe "#sections" do
    before(:all) do
      Supergroups::PolicyAndEngagement.any_instance.stubs(:tagged_content).with(taxon_id).returns(section_tagged_content_list("case_study"))
      Supergroups::Services.any_instance.stubs(:tagged_content).with(taxon_id).returns(section_tagged_content_list("form"))
      Supergroups::GuidanceAndRegulation.any_instance.stubs(:tagged_content).with(taxon_id).returns(section_tagged_content_list("guide"))
      Supergroups::NewsAndCommunications.any_instance.stubs(:tagged_content).with(taxon_id).returns([])
      Supergroups::Transparency.any_instance.stubs(:tagged_content).with(taxon_id).returns([])
      Supergroups::ResearchAndStatistics.any_instance.stubs(:tagged_content).with(taxon_id).returns([])
      @sections = supergroup_sections.sections
    end

    it "returns a list of sections with tagged content" do
      assert 5, @sections.length
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

      @sections.each do |section|
        assert_equal(section_details, section.keys)
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

      section_ids = @sections.map { |section| section[:id] }

      section_ids.map do |id|
        assert_includes expected_ids, id
      end
      assert expected_ids, section_ids
    end

    it "knows if each sections should be shown or not" do
      shown_sections = @sections.select { |section| section[:show_section] == true }
      not_show_sections = @sections.select { |section| section[:show_section] == false }

      assert 3, shown_sections.length
      assert 2, not_show_sections.length
    end
  end
end
