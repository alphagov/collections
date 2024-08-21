module BrowseHelper
  def display_popular_links_for_slug?(slug)
    popular_links_data(slug).present?
  end

  def control_key_is_present?(slug)
    I18n.exists?("#{slug}.control", scope: "browse.popular_links")
  end

  def control_data(slug)
    if control_key_is_present?(slug)
      I18n.t("browse.popular_links.#{slug}.control")
    else
      []
    end
  end

  def popular_links_data(slug)
    if popular_tasks_variant_a_page?
      I18n.t("browse.popular_links.#{slug}.variant_a")
    elsif popular_tasks_variant_b_page?
      I18n.t("browse.popular_links.#{slug}.variant_b")
    else
      control_data(slug)
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
          },
        },
      }
    end
  end
end
