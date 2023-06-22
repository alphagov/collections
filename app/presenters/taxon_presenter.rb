class TaxonPresenter
  attr_reader :taxon

  delegate(
    :content_id,
    :title,
    :description,
    :base_path,
    :child_taxons,
    :live_taxon?,
    :section_content,
    :organisations,
    to: :taxon,
  )

  def initialize(taxon)
    @taxon = taxon
  end

  def sections
    @sections ||= SupergroupSections.supergroup_sections(taxon.content_id, taxon.base_path)
  end

  def organisations_section
    @organisations_section ||= TaxonOrganisationsPresenter.new(organisations, count_sections, page_section_total)
  end

  def show_subtopic_grid?
    child_taxons.count.positive?
  end

  def options_for_child_taxon(index:)
    {
      module: "gem-track-click",
      track_category: "navGridContentClicked",
      track_action: (index + 1).to_s,
      track_label: child_taxons[index].preferred_url,
      track_options: {},
      ga4_link: {
        event_name: "navigation",
        type: "document list",
        index: {
          index_link: (index + 1).to_s,
          index_section: page_section_total.to_s,
          index_section_count: page_section_total.to_s,
        },
        index_total: child_taxons.count,
        section: I18n.t("taxons.explore_sub_topics"),
      },
    }
  end

  def count_sections
    sections.select { |s| s[:show_section] }.count
  end

  def page_section_total
    count = count_sections
    count += 1 if organisations.any?
    count += 1 if show_subtopic_grid?
    count
  end
end
