module SupergroupSections
  # These should remain in order as the sequence of sections displayed on the
  # page is important.
  SUPERGROUPS = [
    Supergroups::Services.new,
    Supergroups::GuidanceAndRegulation.new,
    Supergroups::NewsAndCommunications.new,
    Supergroups::ResearchAndStatistics.new,
    Supergroups::PolicyAndEngagement.new,
    Supergroups::Transparency.new,
  ].freeze

  def self.supergroup_sections(taxon_id, base_path)
    supergroups = Sections.new(taxon_id, base_path)
    supergroups.sections
  end
end
