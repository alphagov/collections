module BrowseHelper
  def slug(path = base_path)
    path.sub(%r{.*(?=/browse/)}, "")
  end

  def display_popular_tasks_for_slug?(slug)
    %w[benefits business].include?(slug)
  end

  def popular_links_for_slug(slug)
    browse_page = slug(slug)

    # Cache keys for the specific browse page
    cache_key_latest = "popular_tasks_#{browse_page}_#{Date.yesterday.strftime("%Y-%m-%d")}"
    cache_key_backup = "popular_tasks_backup_#{browse_page}"

    # Try to fetch the latest cache first
    popular_task_data = Rails.cache.read(cache_key_latest)

    # If the latest cache doesn't exist, fall back to the backup cache
    if popular_task_data.nil?
      # Falling back to backup cache
      popular_task_data = Rails.cache.read(cache_key_backup)
    end

    # If both caches are empty, fetch fresh data and cache it
    if popular_task_data.nil?
      popular_task_data = PopularTasks.new.fetch_data("/browse/#{browse_page}")
    end

    popular_task_data
  end
end
