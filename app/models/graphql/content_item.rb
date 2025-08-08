class Graphql::ContentItem < ContentItem
  def self.find!(base_path)
    content_item = Services.publishing_api.graphql_live_content_item(base_path)
    content_item_hash = content_item.to_h
    content_item_hash["cache_control"] = {
      "max_age" => content_item.cache_control["max-age"],
      "public" => !content_item.cache_control.private?,
    }
    new(content_item_hash)
  end
end
