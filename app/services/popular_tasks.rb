class PopularTasks
  POPULAR_TASKS_SOURCE_DATA_FILE_PATH = "lib/data/popular_tasks.yml".freeze
  NUMBER_OF_TASKS_TO_DISPLAY = 3

  def initialize(slug)
    @slug = slug
  end

  attr_reader :slug

  def popular_links_for_slug
    count = NUMBER_OF_TASKS_TO_DISPLAY
    links_to_display.map.with_index(1) do |link, index|
      {
        text: link["title"],
        href: link["link"],
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

private

  def popular_tasks_source_data
    source_data_path = Rails.root.join(POPULAR_TASKS_SOURCE_DATA_FILE_PATH)
    data = YAML.load_file(source_data_path)
    data["popular_tasks"]
  end

  def unordered_links
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

  def links_ordered_by_popularity
    links = unordered_links.map do |link|
      search_response = fetch_popularity(link)
      search_response["results"].first
    end
    links.compact.sort_by { |k| -k["popularity"] }
  end

  def links_to_display
    links_ordered_by_popularity.first(NUMBER_OF_TASKS_TO_DISPLAY)
  end
end
