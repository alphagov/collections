module BrowseHelper
  def display_popular_links_for_slug?(slug)
    popular_links_data(slug).present?
  end

  def popular_links_data(slug)
    if I18n.exists?("browse.popular_links.#{slug}", :en)
      I18n.t("browse.popular_links.#{slug}")
    end
  end

  def popular_links_for_slug(slug)
    links = popular_links_data(slug)
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
            section: "Popular tasks",
          },
        },
      }
    end
  end
end
