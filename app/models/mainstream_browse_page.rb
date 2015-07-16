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
    linked_items("related_topics")
  end

  def slug
    base_path.sub(%r{\A/browse/}, '')
  end

private

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
