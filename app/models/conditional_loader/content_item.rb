class ConditionalLoader::ContentItem < ContentItem
  def self.find!(request)
    loader = GovukConditionalContentItemLoader.new(request: request)
    content_item = loader.load
    content_item_hash = content_item.to_hash
    content_item_hash["cache_control"] = {
      "max_age" => content_item.cache_control["max-age"],
      "public" => !content_item.cache_control.private?,
    }
    new(content_item_hash)
  end
end
