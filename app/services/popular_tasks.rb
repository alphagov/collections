class PopularTasks
  POPULAR_TASKS_SOURCE_DATA_FILE_PATH = "lib/data/popular_tasks.yml".freeze

  def popular_tasks_source_data
    source_data_path = Rails.root.join(POPULAR_TASKS_SOURCE_DATA_FILE_PATH)
    data = YAML.load_file(source_data_path)
    data["popular_tasks"]
  end

  def unordered_links(slug)
    @unordered_links ||= popular_tasks_source_data[slug]
  end

  def fetch_popularity(url)
    Services.cached_search(
      {
        filter_link: url,
        fields: SearchApiFields::POPULARITY_SEARCH_FIELDS,
      },
      expiry: 12.hours,
    )
  end

  def links_ordered_by_popularity(slug)
    links = unordered_links(slug).map do |link|
      search_response = fetch_popularity(link)
      search_response["results"].first
    end
    links.sort_by { |k| -k["popularity"] }
  end
end
