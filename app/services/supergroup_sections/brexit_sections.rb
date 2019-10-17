module SupergroupSections
  class BrexitSections
    def initialize(taxon_id, base_path)
      @taxon_id = taxon_id
      @base_path = base_path
    end

    def sections
      SUPERGROUPS.map do |supergroup|
        {
          name: supergroup.name,
          see_more_link: supergroup.finder_link(base_path, taxon_id),
          title: I18n.t("brexit_sections.#{supergroup.name}.title"),
        }
      end
    end

  private

    attr_reader :taxon_id, :base_path
  end
end
