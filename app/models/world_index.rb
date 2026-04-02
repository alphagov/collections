class WorldIndex
  attr_reader :content_item

  def initialize(content_item)
    @content_item = content_item
  end

  def self.find!(request)
    content_item = ContentItem.find!(request)
    new(content_item)
  end
end
