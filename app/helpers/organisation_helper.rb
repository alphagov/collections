module OrganisationHelper
  def child_organisation_count(organisation)
    child_orgs = organisation.content_item.content_item_data["links"]["ordered_child_organisations"]
    child_orgs.present? ? child_orgs.count : 0
  end

  def show_organisation(organisation)
    if organisation.content_item.content_item_data["details"]["organisation_govuk_status"]["status"] == "live"
      render partial: 'show_organisation',
             locals: { organisation: @organisation }
    else
      render partial: 'separate_website',
             locals: { organisation: @organisation }
    end
  end
end
