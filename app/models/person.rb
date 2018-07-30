require 'active_model'

class Person
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

  def roles
    links["ordered_current_appointments"].map { |ra| ra["title"] }.to_sentence
  end

  def image_url
    details.dig("image", "url")
  end

  def image_alt_text
    details.dig("image", "alt_text")
  end

  def biography
    details["body"]
  end

  def web_url
    Plek.current.website_root + base_path
  end

private

  def links
    @content_item.content_item_data["links"]
  end

  def details
    @content_item.content_item_data["details"]
  end
end
