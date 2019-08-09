class BrexitLandingPagePresenter
  attr_reader :taxon
  delegate(
    :content_id,
    :title,
    :description,
    :base_path,
    :child_taxons,
    :live_taxon?,
    :section_content,
    to: :taxon
  )

  def initialize(taxon)
    @taxon = taxon
  end

  def sections
    sections ||= SupergroupSections.supergroup_sections(taxon.content_id, taxon.base_path)

    sections.map do |section|
      if section[:show_section]
        {
        text: I18n.t(section[:id], scope: :content_purpose_supergroup, default: section[:title]),
        path: section[:see_more_link][:url],
        data_attributes: section[:see_more_link][:data]
        }
      end
    end
  end

  def brexit?
    content_id == "d6c2de5d-ef90-45d1-82d4-5f2438369eea"
  end
end
