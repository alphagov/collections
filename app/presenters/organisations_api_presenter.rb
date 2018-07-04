class OrganisationsApiPresenter
  include OrganisationHelper
  include PaginationHelper

  attr_reader :organisations,
              :current_page,
              :results_per_page,
              :total_results,
              :current_url_without_parameters,
              :wrap_in_results_array

  def initialize(organisations,
    current_page:,
    results_per_page:,
    total_results:,
    current_url_without_parameters:,
    wrap_in_results_array: true)
    @organisations = organisations
    @current_page = current_page
    @results_per_page = results_per_page
    @total_results = total_results
    @current_url_without_parameters = current_url_without_parameters
    @wrap_in_results_array = wrap_in_results_array
  end

  def present
    o = organisations.map do |organisation|
      organisation = organisation["organisations"][0]
      {
        id: api_url_from_slug(organisation["slug"]),
        title: organisation["title"].gsub("Closed organisation: ", ""),
        format: organisation_type_name(organisation["organisation_type"]),
        updated_at: organisation["public_timestamp"],
        web_url: web_url_from_slug(organisation["slug"]),
        details: {
          slug: organisation["slug"],
          abbreviation: organisation["acronym"],
          logo_formatted_name: organisation["logo_formatted_title"],
          organisation_brand_colour_class_name: organisation["organisation_brand"],
          organisation_logo_type_class_name: organisation["organisation_crest"],
          closed_at: organisation["closed_at"],
          govuk_status: organisation["organisation_state"],
          govuk_closed_status: organisation["organisation_closed_state"],
          content_id: organisation["content_id"],
        },
        analytics_identifier: organisation["analytics_identifier"],
        parent_organisations: summary_organisations(organisation, "parent_organisations"),
        child_organisations: summary_organisations(organisation, "child_organisations"),
        superseded_organisations: summary_organisations(organisation, "superseded_organisations"),
        superseding_organisations: summary_organisations(organisation, "superseding_organisations"),
      }
    end

    paginate(o, wrap_in_results_array)
  end

private

  def api_url_from_slug(slug)
    "#{Plek.new.website_root}#{Rails.application.routes.url_helpers.api_organisation_path(organisation_name: slug)}"
  end

  def web_url_from_slug(slug)
    "#{Plek.new.website_root}#{Rails.application.routes.url_helpers.organisation_path(organisation_name: slug)}"
  end

  def summary_organisations(organisation, type)
    return [] if organisation[type].nil?

    organisation[type].map do |slug|
      {
        id: api_url_from_slug(slug),
        web_url: web_url_from_slug(slug),
      }
    end
  end
end
