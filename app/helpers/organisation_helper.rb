module OrganisationHelper
  def child_organisation_count(organisation)
    child_orgs = organisation.content_item.content_item_data["links"]["ordered_child_organisations"]
    child_orgs.present? ? child_orgs.count : 0
  end

  def organisation_type_name(organisation_type)
    I18n.t("organisations.type.#{organisation_type}", default: I18n.t("organisations.type.other"))
  end

  def image_url_by_size(image_url, size)
    image_url_array = image_url.split("/")
    image_by_size_name = "s#{size}_" + image_url_array[-1]
    image_url_array[-1] = image_by_size_name

    image_url_array.join("/")
  end

  def search_results_to_documents(search_results, organisation, include_metadata: true)
    {
      brand: (organisation.brand if organisation.is_live?),
      items: search_results.map do |result|
        Organisations::DocumentPresenter.new(result, include_metadata: include_metadata).present
      end,
    }
  end

  def array_of_links_to_organisations(organisations)
    organisations.map do |organisation|
      link_to organisation[:title], organisation, class: "organisation-link govuk-link"
    end
  end
end
