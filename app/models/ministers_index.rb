require "active_model"

class MinistersIndex
  include ActiveModel::Model

  attr_reader :content_item

  def initialize(content_item)
    @content_item = content_item
  end

  def self.find!(request)
    content_item = ConditionalLoader::ContentItem.find!(request)
    new(content_item)
  end
end
