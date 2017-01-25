class ServicesAndInformationController < ApplicationController
  def index
    setup_navigation_helpers(content_item)

    render :index, locals: {
      content_item: content_item,
      organisation: organisation,
      grouped_links: grouped_links
    }
  end

private

  def base_path
    "/government/organisations/#{params[:organisation_id]}/services-information"
  end

  def content_item
    Services.content_store.content_item!(base_path)
  end

  def grouped_links
    links_grouper =
      ServicesAndInformationLinksGrouper.new(params[:organisation_id])

    links_grouper.parsed_grouped_links.reject do |group|
      group["title"].nil?
    end
  end

  def organisation
    content_item.to_hash.dig("links", "parent", 0)
  end
end
