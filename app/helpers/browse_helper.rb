module BrowseHelper
  def display_popular_links_for_slug?(slug)
    I18n.exists?(slug.to_s, scope: "browse.popular_links")
  end

  def each_popular_link_for_slug(slug)
    links = I18n.t(slug.to_s, scope: "browse.popular_links")
    count = links.length
    links.each.with_index(1) do |link, index|
      analytics_text = I18n.t(link[:analytics_label_key], scope: "browse.analytics_labels", locale: :en)
      yield link, analytics_text, index, count
    end
  end
end
