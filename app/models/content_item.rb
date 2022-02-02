class ContentItem
  attr_reader :content_item_data

  def self.find!(base_path)
    content_item = Services.content_store.content_item(base_path)
    content_item_hash = content_item.to_h
    content_item_hash["cache_control"] = {
      "max_age" => content_item.cache_control["max-age"],
      "public" => !content_item.cache_control.private?,
    }
    new(content_item_hash)
  end

  def initialize(content_item_data)
    @content_item_data = content_item_data
  end

  %i[base_path title description content_id document_type locale cache_control].each do |field|
    define_method field do
      @content_item_data[field.to_s]
    end
  end

  def details
    @content_item_data["details"] || {}
  end

  def max_age
    @content_item_data.dig("cache_control", "max_age") || 5.minutes
  end

  def public_cache
    public_cache = @content_item_data.dig("cache_control", "public")
    public_cache.nil? ? true : public_cache
  end

  def linked_items(field)
    return [] unless @content_item_data["links"]

    @content_item_data["links"][field].to_a.map { |item_hash|
      self.class.new(item_hash)
    }.select(&:title).sort_by(&:title)
  end

  def to_hash
    @content_item_data
  end

  def merge(to_merge)
    ContentItem.new(content_item_data.merge(to_merge))
  end

  def phase
    @content_item_data.fetch("phase")
  rescue KeyError => e
    raise "Error searching content item: #{e}"
  end
end
