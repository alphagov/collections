class ServicesAndInformationController < ApplicationController
  before_action :configure_ab_response, if: :page_in_ab_test?

  def index
    setup_content_item_and_navigation_helpers(service_and_information)

    taxon_resolver = TaxonRedirectResolver.new(
      ab_variant,
      page_is_in_ab_test: page_in_ab_test?,
      map_to_taxon: "education"
    )

    if taxon_resolver.redirect?
      redirect_to(
        controller: "taxons",
        action: "show",
        taxon_base_path: taxon_resolver.taxon_base_path,
        anchor: taxon_resolver.fragment
      )
    else
      render :index, locals: {
        service_and_information: service_and_information,
        organisation: service_and_information.organisation,
        grouped_links: grouped_links,
        is_page_under_ab_test: page_in_ab_test?,
        ab_variant: ab_variant,
      }
    end
  end

private

  def page_in_ab_test?
    params[:organisation_id] == "department-for-education"
  end

  def base_path
    "/government/organisations/#{params[:organisation_id]}/services-information"
  end

  def service_and_information
    ServiceAndInformation.find!(base_path)
  end

  def grouped_links
    links_grouper =
      ServicesAndInformationLinksGrouper.new(params[:organisation_id])

    links_grouper.parsed_grouped_links.reject do |group|
      group.title.nil?
    end
  end
end
