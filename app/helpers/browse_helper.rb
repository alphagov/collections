module BrowseHelper
  def display_popular_links_for_slug?(slug)
    I18n.exists?(slug.to_s, scope: "browse.popular_links")
  end

  def popular_links_for_slug(slug)
    links = I18n.t(slug.to_s, scope: "browse.popular_links")
    count = links.length
    links.map.with_index(1) do |link, index|
      {
        text: link[:title],
        href: link[:url],
        data_attributes: {
          module: "ga4-link-tracker",
          ga4_track_links_only: "",
          ga4_link: {
            event_name: "navigation",
            type: "action",
            index_link: index,
            index_total: count,
            text: link[:title],
          },
        },
      }
    end
  end
end
