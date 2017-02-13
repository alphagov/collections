class ServicesAndInformationController < ApplicationController
  def index
    setup_content_item_and_navigation_helpers(service_and_information)

    taxon_resolver = TaxonRedirectResolver.new(
      request,
      is_page_in_ab_test: lambda { params[:organisation_id] == "department-for-education" },
      map_to_taxon: lambda { "education" }
    )

    if taxon_resolver.page_ab_tested?
      taxon_resolver.ab_variant.configure_response(response)
    end

    if taxon_resolver.taxon_base_path
      redirect_to controller: "taxons",
        action: "show",
        taxon_base_path: taxon_resolver.taxon_base_path
    else
      render :index, locals: {
        service_and_information: service_and_information,
        organisation: service_and_information.organisation,
        grouped_links: grouped_links,
        is_page_under_ab_test: taxon_resolver.page_ab_tested?,
        ab_variant: taxon_resolver.ab_variant,
      }
    end
  end

private

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
      group["title"].nil?
    end
  end
end
