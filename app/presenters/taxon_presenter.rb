class TaxonPresenter
  attr_reader :taxon
  delegate(
    :content_id,
    :title,
    :description,
    :base_path,
    :tagged_content,
    :child_taxons,
    :live_taxon?,
    :section_content,
    :organisations,
    to: :taxon
  )

  def initialize(taxon)
    @taxon = taxon
  end

  def sections
    SupergroupSections.supergroup_sections(taxon.content_id, taxon.base_path)
  end

  def show_subtopic_grid?
    child_taxons.count.positive?
  end

  def options_for_child_taxon(index:)
    {
      module: 'track-click',
      track_category: 'navGridContentClicked',
      track_action: (index + 1).to_s,
      track_label: child_taxons[index].base_path,
      track_options: { dimension26: tagged_content.any? ? '2' : '1',
                       dimension27: (child_taxons.length + tagged_content.length).to_s,
                       dimension28: child_taxons.size.to_s,
                       dimension29: child_taxons[index].title }
    }
  end

  def taxon_organisations
    organisations.map do |organisation|
      {
        link: {
          text: organisation.title,
          path: organisation.link
        }
      }
    end
  end

  def show_organisations?
    organisations.any?
  end
end
