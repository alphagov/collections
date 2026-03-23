class Role
  attr_reader :content_item

  def initialize(content_item)
    @content_item = content_item
  end

  def self.find_content_item!(request)
    loader = GovukConditionalContentItemLoader.new(request: request)
    content_item = loader.load.to_hash
    new(content_item)
  end
end
