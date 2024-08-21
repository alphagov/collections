module BrowseHelper
  def variant_a_popular_links?(slug)
    I18n.exists?("#{slug}.variant_a", scope: "browse.popular_links")
  end

  def variant_a_popular_links(slug)
    I18n.t("#{slug}.control", scope: "browse.popular_links")
  end

  def variant_b_popular_links?(slug)
    I18n.exists?("#{slug}.variant_b", scope: "browse.popular_links")
  end

  def variant_b_popular_links(slug)
    I18n.t("#{slug}.control", scope: "browse.popular_links")
  end

  def control_popular_links?(slug)
    I18n.exists?("#{slug}.control", scope: "browse.popular_links")
  end

  def control_popular_links(slug)
    I18n.t("#{slug}.control", scope: "browse.popular_links")
  end

  def display_popular_links_for_slug?(slug)
    if popular_tasks_variant_a_page?
      variant_a_popular_links?(slug)
    elsif popular_tasks_variant_b_page?
      variant_b_popular_links?(slug)
    else
      control_popular_links?(slug)
    end
  end

  def variant_popular_links_for_slug(slug)
    if popular_tasks_variant_a_page?
      variant_a_popular_links(slug)
    elsif popular_tasks_variant_b_page?
      variant_b_popular_links(slug)
    else
      control_popular_links(slug)
    end
  end

  def popular_links_for_slug(slug)
    links = variant_popular_links_for_slug(slug)
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
