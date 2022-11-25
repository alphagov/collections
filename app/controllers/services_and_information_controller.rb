class ServicesAndInformationController < ApplicationController
  def index
    setup_content_item_and_navigation_helpers(service_and_information)
    render :index,
           locals: {
             service_and_information:,
             organisation: service_and_information.organisation,
             grouped_links:,
           }
  end

private

  def base_path
    "/government/organisations/#{params[:organisation_id]}/services-information"
  end

  def service_and_information
    @service_and_information ||= ServiceAndInformation.find!(base_path)
  end

  def grouped_links
    links_grouper =
      ServicesAndInformationLinksGrouper.new(params[:organisation_id])

    links_grouper.parsed_grouped_links.reject do |group|
      group.title.nil?
    end
  end
end
