class ContentItem
  def self.find!(base_path)
    Collections.services(:content_store).content_item!(base_path)
  end
end
