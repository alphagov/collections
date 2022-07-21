module TopicBrowseHelper

  def browse_to_topic_mapping(path)
    mappings.find { |m| m["browse_path"] == path }
  end

  def topic_as_browse_mapping(request)
    mapping = mappings.find { |m| m["topic_path"] == request.path }
    return unless mapping

    referer = URI(request.referer)
    return if (request.path).include?(referer.path)
    mapping
  end

  def mappings
    @mappings ||= YAML.load_file(Rails.root.join("config/topic_browse.yml").to_s)["mappings"]
  end
end
