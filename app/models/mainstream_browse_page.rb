class MainstreamBrowsePage

  def self.find(base_path)
    api_response = ContentItem.find!(base_path)
    new(api_response.to_hash)
  end

  def initialize(content_item_data)
    @content_item_data = content_item_data
  end

  [
    :base_path,
    :title,
    :description,
  ].each do |field|
    define_method field do
      @content_item_data[field.to_s]
    end
  end

  def top_level_browse_pages
    linked_items("top_level_browse_pages")
  end

  def active_top_level_browse_page
    linked_items("active_top_level_browse_page").first
  end

  def second_level_browse_pages
    linked_items("second_level_browse_pages")
  end

  def second_level_pages_curated?
    @content_item_data["details"] && @content_item_data["details"]["second_level_ordering"] == "curated"
  end

  def lists
    @lists ||= ListSet.new("section", slug, groups)
  end

  def related_topics
    @related_topics ||= build_related_topics
  end

  def slug
    base_path.sub(%r{\A/browse/}, '')
  end

private

  # FIXME: this can be replaced with a simple call to linked_items once we no
  # longer need to support whitehall detailed guide categories
  def build_related_topics
    topics = linked_items("related_topics")
    return topics if topics.any?

    Collections.services(:detailed_guidance_content_api).sub_sections(slug).results.map do |item|
      LinkedContentItem.new(
        item.title,
        item.content_with_tag.web_url,
      )
    end.sort_by(&:title)
  rescue GdsApi::HTTPNotFound # Whitehall returns 404, not empty array with no categories.
    return []
  end

  def linked_items(field)
    if @content_item_data.has_key?("links") &&
        @content_item_data["links"].has_key?(field)
      @content_item_data["links"][field].map { |item_details|
        LinkedContentItem.build(item_details)
      }
    else
      []
    end
  end

  def groups
    @content_item_data["details"] && @content_item_data["details"]["groups"]
  end
end
