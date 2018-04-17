require 'test_helper'

include RummagerHelpers
include TaxonHelpers

describe SupergroupSections::Sections do
  let(:taxon_id) { '12345' }
  let(:base_path) { '/base/path' }
  let(:supergroup_sections) { SupergroupSections::Sections.new(taxon_id, base_path) }

  describe '#sections' do
    before(:all) do
      Supergroups::PolicyAndEngagement.any_instance.stubs(:tagged_content).with(taxon_id).returns(section_tagged_content_list('case_study'))
      Supergroups::Services.any_instance.stubs(:tagged_content).with(taxon_id).returns(section_tagged_content_list('form'))
      Supergroups::GuidanceAndRegulation.any_instance.stubs(:tagged_content).with(taxon_id).returns(section_tagged_content_list('guide'))
      Supergroups::NewsAndCommunications.any_instance.stubs(:tagged_content).with(taxon_id).returns([])
      Supergroups::Transparency.any_instance.stubs(:tagged_content).with(taxon_id).returns([])
      @sections = supergroup_sections.sections
    end

    it 'returns a list of sections with tagged content' do
      assert 5, @sections.length
    end

    it 'returns a list of supergroup details' do
      @sections.each do |section|
        assert_equal(%i(title documents partial_template promoted_content_count see_more_link show_section), section.keys)
      end
    end

    it 'each section has a title' do
      expected_titles = [
        'Services',
        'Guidance and regulation',
        'News and communications',
        'Policy and engagement',
        'Transparency'
      ]

      section_titles = @sections.map { |section| section[:title] }

      section_titles.map do |title|
        assert_includes expected_titles, title
      end
      assert expected_titles, section_titles
    end

    it 'knows if each sections should be shown or not' do
      shown_sections = @sections.select { |section| section[:show_section] == true }
      not_show_sections = @sections.select { |section| section[:show_section] == false }

      assert 3, shown_sections.length
      assert 2, not_show_sections.length
    end
  end
end
