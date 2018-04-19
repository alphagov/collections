module SupergroupSections
  # These should remain in order as the sequence of sections displayed on the
  # page is important.
  SUPERGROUPS = [
    Supergroups::Services,
    Supergroups::GuidanceAndRegulation,
    Supergroups::NewsAndCommunications,
    Supergroups::PolicyAndEngagement,
    Supergroups::Transparency
  ].freeze

  def self.supergroup_sections(taxon_id, base_path)
    supergroups = Sections.new(taxon_id, base_path)
    supergroups.sections
  end

  class Sections
    attr_reader :taxon_id, :base_path

    def initialize(taxon_id, base_path)
      @taxon_id = taxon_id
      @base_path = base_path
    end

    def sections
      SupergroupSections::SUPERGROUPS.map do |supergroup_class|
        supergroup = supergroup_class.new(filter_part_of_taxonomy_tree: [taxon_id])
        {
          title: supergroup.title,
          documents: supergroup.document_list,
          partial_template: supergroup.partial_template,
          see_more_link: supergroup.finder_link(base_path),
          show_section: supergroup.show_section?
        }
      end
    end
  end
end
