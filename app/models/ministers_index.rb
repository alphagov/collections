require "active_model"

class MinistersIndex
  include ActiveModel::Model

  attr_reader :content_item

  def initialize(content_item)
    @content_item = content_item
  end

  #def self.find!(base_path)
  #  content_item = ContentItem.find!(base_path)
  #  new(content_item)
  #end

  #replace both of these with one call to the content loader gem

  def self.find_content_item!(request)
    loader = GovukConditionalContentItemLoader.new(request: request)
    content_item = loader.load.to_hash
    new(content_item)
  end
#
  #def self.find_from_graphql!(base_path)
  #  content_item = Graphql::ContentItem.find!(base_path)
  #  new(content_item)
  #end
end
