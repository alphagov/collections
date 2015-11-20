class ContentItem
  def self.find!(base_path)
    response = Services.content_store.content_item!(base_path)
    new(response.to_hash)
  end

  def initialize(content_item_data)
    @content_item_data = content_item_data
  end

  %i[base_path title description content_id].each do |field|
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
    }.sort_by(&:title)
  end
end
