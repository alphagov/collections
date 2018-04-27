class TaxonPresenter
  ORG_PROMOTED_CONTENT_COUNT = 5

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

  def promoted_organisation_list
    promoted_organisations_with_logos = organisation_list_with_logos.shift(ORG_PROMOTED_CONTENT_COUNT)
    promoted_organisations_without_logos = organisation_list_without_logos.shift(ORG_PROMOTED_CONTENT_COUNT - promoted_organisations_with_logos.count)

    {
      "promoted_with_logos": promoted_organisations_with_logos,
      "promoted_without_logos": promoted_organisations_without_logos
    }
  end

  def show_more_organisation_list
    {
      "organisations_with_logos": organisation_list_with_logos.drop(ORG_PROMOTED_CONTENT_COUNT),
      "organisations_without_logos": organisation_list_without_logos.drop(ORG_PROMOTED_CONTENT_COUNT - promoted_organisation_list[:promoted_with_logos].count)
    }
  end

  def show_more_organisations?
    show_more_organisation_list.values.flatten.any?
  end

  def show_organisations?
    organisations.any?
  end

private

  def organisations_with_logos
    organisations.select(&:has_logo?)
  end

  def organisation_list_with_logos
    organisations_with_logos.map do |org|
      {

          name: org.logo_formatted_title,
          url: org.link,
          brand: org.brand,
          crest: org.crest,
      }
    end
  end

  def organisation_list_without_logos
    orgs = organisations - organisations_with_logos

    orgs.map do |organisation|
      {
        link: {
          text: organisation.title,
          path: organisation.link
        }
      }
    end
  end
end
