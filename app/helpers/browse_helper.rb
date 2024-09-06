module BrowseHelper
  def slug(path = base_path)
    path.sub(%r{.*(?=/browse/)}, "")
  end

  def display_popular_tasks_for_slug?(slug)
    %w[benefits business].include?(slug)
  end

  def popular_links_for_slug(slug)
    browse_page = slug(slug)

    # Try to fetch the cache first
    popular_task_data = Rails.cache.read("popular_tasks_#{browse_page}_#{Date.yesterday.strftime("%Y-%m-%d")}")

    # If cache is empty fetch fresh data and cache it
    if popular_task_data.nil?
      popular_task_data = PopularTasks.new.fetch_data("/browse/#{browse_page}")
    end

    return [] unless popular_task_data

    popular_task_data
  end
end
