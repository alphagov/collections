class WorldIndexPresenter
  include ActionView::Helpers::UrlHelper

  delegate :count, to: :world_locations, prefix: true
  delegate :count, to: :international_delegations, prefix: true

  def initialize(content_item_data)
    @content_item_data = content_item_data
  end

  def title
    @content_item_data.fetch("title")
  end

  def grouped_world_locations
    @content_item_data.dig("details", "world_locations")
      .group_by { |location| location_group(location) }
      .sort
  end

  def international_delegations
    @content_item_data.dig("details", "international_delegations")
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
    @content_item_data.fetch("details")
  end

  def world_locations
    @content_item_data.dig("details", "world_locations")
  end
end
