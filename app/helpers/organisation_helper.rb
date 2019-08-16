module OrganisationHelper
  ORGANISATION_TYPES = {
    executive_office:            { name: "Executive office" },
    ministerial_department:      { name: "Ministerial department" },
    non_ministerial_department:  { name: "Non-ministerial department" },
    executive_agency:            { name: "Executive agency" },
    executive_ndpb:              { name: "Executive non-departmental public body" },
    advisory_ndpb:               { name: "Advisory non-departmental public body" },
    tribunal_ndpb:               { name: "Tribunal non-departmental public body" },
    tribunal:                    { name: "Tribunal" },
    public_corporation:          { name: "Public corporation" },
    independent_monitoring_body: { name: "Independent monitoring body" },
    adhoc_advisory_group:        { name: "Ad-hoc advisory group" },
    devolved_administration:     { name: "Devolved administration" },
    sub_organisation:            { name: "Sub-organisation" },
    other:                       { name: "Other" },
    civil_service:               { name: "Civil Service" },
    court:                       { name: "Court" },
  }.freeze

  def child_organisation_count(organisation)
    child_orgs = organisation.content_item.content_item_data["links"]["ordered_child_organisations"]
    child_orgs.present? ? child_orgs.count : 0
  end

  def organisation_type_name(organisation_type)
    ORGANISATION_TYPES.dig(organisation_type.to_sym, :name) || ORGANISATION_TYPES[:other][:name]
  end

  def image_url_by_size(image_url, size)
    image_url_array = image_url.split('/')
    image_by_size_name = "s#{size}_" + image_url_array[-1]
    image_url_array[-1] = image_by_size_name

    image_url_array.join("/")
  end

  def search_results_to_documents(search_results, organisation, include_metadata: true)
    {
      brand: (organisation.brand if organisation.is_live?),
      items: search_results.map { |result|
        Organisations::DocumentPresenter.new(result, include_metadata: include_metadata).present
      }
    }
  end
end
