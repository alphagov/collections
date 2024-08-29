class PopularTasks
  POPULAR_TASKS_SOURCE_DATA_FILE_PATH = "lib/data/popular_tasks.yml".freeze

  def popular_tasks_source_data
    source_data_path = Rails.root.join(POPULAR_TASKS_SOURCE_DATA_FILE_PATH)
    data = YAML.load_file(source_data_path)
    data["popular_tasks"]
  end
end
