class TopicalEvent
  attr_reader :content_item

  def initialize(content_item)
    @content_item = content_item
  end

  def self.find!(base_path)
    content_item = ContentItem.find!(base_path)
    new(content_item)
  end

  def title
    @content_item.content_item_data["title"]
  end

  def description
    @content_item.content_item_data["description"]
  end

  def body
    @content_item.content_item_data.dig("details", "body")
  end

  def end_date
    Date.parse(@content_item.content_item_data.dig("details", "end_date")) if @content_item.content_item_data.dig("details", "end_date")
  end

  def archived?
    if end_date && end_date <= Time.zone.today
      true
    else
      false
    end
  end
end
