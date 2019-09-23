require "active_model"

class Role
  include ActiveModel::Model

  attr_reader :content_item

  def initialize(content_item)
    @content_item = content_item
  end

  def self.find!(base_path)
    content_item = ContentItem.find!(base_path)
    new(content_item)
  end

  def base_path
    @content_item.content_item_data["base_path"]
  end

  def title
    @content_item.content_item_data["title"]
  end

  def responsibilities
    details["body"]
  end

private

  def links
    @content_item.content_item_data["links"]
  end

  def details
    @content_item.content_item_data["details"]
  end
end
