module BrowseHelper
  def with_tracking_data(popular_content)
    count = popular_content.length
    popular_content.map.with_index(1) do |page, index|
      {
        text: page[:title],
        href: page[:link],
        data_attributes: {
          module: "ga4-link-tracker",
          ga4_track_links_only: "",
          ga4_link: {
            event_name: "navigation",
            type: "action",
            index_link: index,
            index_total: count,
            text: page[:title],
            section: "Popular tasks",
          },
        },
      }
    end
  end
end
