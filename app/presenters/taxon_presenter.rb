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

  def organisation_list
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

  def organisation_list_with_logos
    organisations_with_logos.map do |org|
      data = {

          name: org.logo_formatted_title,
          url: org.link,
          brand: org.brand,
          crest: org.crest
      }

      if org.logo_url
        data[:crest] = nil

        image = {
          url: org.logo_url,
          alt_text: org.title
        }
        data[:image] = image
      end

      data
    end
  end

  def organisations_with_logos
    organisations.select(&:has_logo?)
  end

  def show_organisations?
    organisations.any?
  end
end
