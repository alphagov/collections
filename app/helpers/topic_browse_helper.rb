module TopicBrowseHelper
  def topic_browse_mapping(path)
    check_browse_paths(path) || check_topic_paths(path)
  end

  def check_browse_paths(path)
    mappings.find { |m| m["browse_path"] == path }
  end

  def check_topic_paths(path)
    mappings.find { |m| m["topic_path"] == path }
  end

  def mappings
    @mappings ||= YAML.load_file(Rails.root.join("config/topic_browse.yml").to_s)["mappings"]
  end
end
