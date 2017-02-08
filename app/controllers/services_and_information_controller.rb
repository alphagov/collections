class ServicesAndInformationController < ApplicationController
  def index
    setup_content_item_and_navigation_helpers(service_and_information)

    is_ab_test_active = false

    if new_navigation_enabled? && params[:organisation_id] == "department-for-education"
      ab_variant = GovukAbTesting::AbTest.new("EducationNavigation").requested_variant(request)
      ab_variant.configure_response(response)

      if ab_variant.variant_b?
        return redirect_to controller: "taxons",
          action: "show",
          taxon_base_path: "education"
      end

      is_ab_test_active = true
    end

    render :index, locals: {
      service_and_information: service_and_information,
      organisation: service_and_information.organisation,
      grouped_links: grouped_links,
      is_ab_test_active: is_ab_test_active,
    }
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
