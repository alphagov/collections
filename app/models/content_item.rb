class ContentItem
  def self.find!(base_path)
    Services.content_store.content_item!(base_path)
  end
end
