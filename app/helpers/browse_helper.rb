module BrowseHelper
  def slug(path = base_path)
    path.sub(%r{.*(?=/browse/)}, "")
  end

  def display_popular_tasks_for_slug?(slug)
    %w[benefits business].include?(slug)
  end

  def select_browse_page(browse_page = "/browse/benefits")
    browse_page = slug(browse_page)
    popular_task_data = PopularTasks.new.fetch_data
    popular_task_data.select { |link| link[:browse_page] == "/browse/#{browse_page}" }
  end

  def popular_links_for_slug(slug)
    links = select_browse_page(slug)
    return [] unless links

    links
  end
end
