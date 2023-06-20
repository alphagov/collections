class TaxonOrganisationsPresenter
  ORG_PROMOTED_CONTENT_COUNT = 5

  attr_reader :organisations

  def initialize(organisations, index_section, index_section_count)
    @organisations = organisations
    @index_section = index_section + 1
    @index_section_count = index_section_count
  end

  def show_organisations?
    organisations.any?
  end

  def show_more_organisations?
    show_more_organisation_list.values.flatten.any?
  end

  def promoted_organisation_list
    promoted_organisations_with_logos = organisation_list_with_logos.shift(ORG_PROMOTED_CONTENT_COUNT)
    promoted_organisations_without_logos = organisation_list_without_logos.shift(ORG_PROMOTED_CONTENT_COUNT - promoted_organisations_with_logos.count)

    {
      "promoted_with_logos": promoted_organisations_with_logos,
      "promoted_without_logos": promoted_organisations_without_logos,
    }
  end

  def show_more_organisation_list
    {
      "organisations_with_logos": organisation_list_with_logos.drop(ORG_PROMOTED_CONTENT_COUNT),
      "organisations_without_logos": organisation_list_without_logos.drop(ORG_PROMOTED_CONTENT_COUNT - promoted_organisation_list[:promoted_with_logos].count),
    }
  end

private

  def organisations_with_logos
    organisations.select(&:has_logo?)
  end

  def organisation_list_with_logos
    organisations_with_logos.map.with_index do |org, index|
      {
        name: org.logo_formatted_title,
        url: org.link,
        brand: org.brand,
        crest: org.crest,
        data_attributes: data_attributes(org.link, org.title, index + 1),
      }
    end
  end

  def organisation_list_without_logos
    organisations_without_logos = organisations - organisations_with_logos

    tracking_number = organisations_with_logos.count

    organisations_without_logos.map.with_index(1) do |organisation, index|
      {
        link: {
          text: organisation.title,
          path: organisation.link,
          data_attributes: data_attributes(organisation.link, organisation.title, tracking_number + index),
        },
      }
    end
  end

  def data_attributes(base_path, link_text, index)
    {
      track_category: "organisationsDocumentListClicked",
      track_action: index,
      track_label: base_path,
      track_options: {
        dimension29: link_text,
      },
      ga4_link: {
        event_name: "navigation",
        type: "organisation logo",
        index: {
          index_link: index,
          index_section: @index_section,
          index_section_count: @index_section_count,
        },
        index_total: organisations.count,
        section: "Organisations",
      },
    }
  end
end
