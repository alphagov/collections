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
      track_options: {},
    }
  end

  def taxon_organisations_without_logo
    organisations_without_logo.map do |organisation|
      {
        link: {
          text: organisation.title,
          path: organisation.link
        }
      }
    end
  end

  def organisations_with_logo
    organisations.select(&:has_logo?)
  end

  def show_organisation_list?
    organisations_without_logo.any?
  end

  def show_organisation_logos?
    organisations_with_logo.any?
  end

private

  def organisations_without_logo
    organisations.reject(&:has_logo?)
  end
end
