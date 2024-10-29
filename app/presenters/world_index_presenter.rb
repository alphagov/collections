class WorldIndexPresenter
  include ActionView::Helpers::UrlHelper

  delegate :count, to: :world_locations, prefix: true
  delegate :count, to: :international_delegations, prefix: true

  def initialize(world_index)
    @world_index = world_index
  end

  def title
    @world_index.content_item["title"]
  end

  def grouped_world_locations
    world_locations
      .group_by { |location| location_group(location) }
      .sort
  end

  def international_delegations
    @world_index.content_item["internationalDelegations"]
  end

  def world_location_link(world_location)
    return content_tag(:span, world_location["name"]) unless world_location["active"]

    path = "/world/#{world_location['slug']}"
    link_to world_location["name"], path, class: "govuk-link"
  end

  def filter_terms(world_location)
    slug = world_location["slug"]
    name = world_location["name"]

    [slug, name].compact.join(" ")
  end

private

  def location_group(location)
    without_prefix = location["name"].gsub(/^The/, "").strip

    without_prefix.first.upcase
  end

  def details
    @world_index.content_item.details
  end

  def world_locations
    @world_index.content_item["worldLocations"]
  end
end
