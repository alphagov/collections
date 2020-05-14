module ContentItemHelper
  def content_item_description(content_item_url)
    content_item = ContentItem.find!(content_item_url)
    content_item.description
  end
end
