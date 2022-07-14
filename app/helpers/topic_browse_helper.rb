module TopicBrowseHelper
  def topic_browse_mapping(path)
    mappings.find { |m| m["browse_path"] == path }
  end

  def mappings
    @mappings ||= YAML.load_file(Rails.root.join("config/topic_browse.yml").to_s)["mappings"]
  end
end
