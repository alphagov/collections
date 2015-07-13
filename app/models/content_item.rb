class ContentItem
  class NotFound < StandardError; end

  def self.find!(base_path)
    Collections.services(:content_store).content_item!(base_path)
  rescue GdsApi::HTTPNotFound
    raise NotFound
  end
end
