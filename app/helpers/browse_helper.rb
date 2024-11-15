module BrowseHelper
  def with_tracking_data(popular_content)
    count = popular_content.length
    popular_content.map.with_index(1) do |link, index|
      {
        text: link[:title],
        href: link[:link],
        data_attributes: {
          module: "ga4-link-tracker",
          ga4_track_links_only: "",
          ga4_link: {
            event_name: "navigation",
            type: "action",
            index_link: index,
            index_total: count,
            text: link[:title],
            section: "Popular tasks",
          },
        },
      }
    end
  end
end
