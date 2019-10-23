class ContentItem
  attr_reader :content_item_data

  def self.find!(base_path)
    response = Services.content_store.content_item(base_path)
    new(response.to_hash)
  end

  def initialize(content_item_data)
    @content_item_data = content_item_data
  end

  %i[base_path title description content_id document_type locale].each do |field|
    define_method field do
      @content_item_data[field.to_s]
    end
  end

  def details
    @content_item_data["details"] || {}
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
