module SupergroupSections
  # These should remain in order as the sequence of sections displayed on the
  # page is important.
  SUPERGROUPS = [
    Supergroups::Services.new,
    Supergroups::GuidanceAndRegulation.new,
    Supergroups::NewsAndCommunications.new,
    Supergroups::PolicyAndEngagement.new,
    Supergroups::Transparency.new
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
      SupergroupSections::SUPERGROUPS.map do |supergroup|
        {
          title: supergroup.title,
          documents: supergroup.document_list(taxon_id),
          partial_template: supergroup.partial_template,
          promoted_content_count: supergroup.promoted_content_count(taxon_id),
          see_more_link: supergroup.finder_link(base_path),
          show_section: supergroup.show_section?(taxon_id)
        }
      end
    end
  end
end
