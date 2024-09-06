module BrowseHelper
  def slug(path = base_path)
    path.sub(%r{\A/browse/}, "")
  end

  def display_popular_tasks?
    %w[benefits business].include?(slug)
  end

  def select_browse_page(browse_page = "benefits")
    PopularTasks.results.select { |link| link[:browse_page] == browse_page }
  end

  def popular_links_for_slug(slug)
    links = select_browse_page(slug)
    return [] unless links

    links.each_with_index do |link, index|
      link[:text] = I18n.t(link[:lang])
      link[:ga4_text] = I18n.t(link[:lang], locale: :en)
      link[:index_link] = index + 1
      link[:index_total] = links.length
    end
  end
end
