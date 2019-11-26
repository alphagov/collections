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
    content_item_data["base_path"]
  end

  def title
    content_item_data["title"]
  end

  def responsibilities
    details["body"]
  end

  def organisations
    links["ordered_parent_organisations"]
  end

  def current_holder
    links
      .fetch("role_appointments", [])
      .find { |ra| ra.dig("details", "current") }
      .dig("links", "person")
      .first
  end

  def current_holder_biography
    current_holder["details"]["body"]
  end

  def link_to_person
    current_holder["base_path"]
  end

private

  def content_item_data
    content_item.content_item_data
  end

  def links
    content_item_data["links"]
  end

  def details
    content_item_data["details"]
  end
end
