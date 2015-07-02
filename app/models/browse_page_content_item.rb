class BrowsePageContentItem
  attr_reader :slug, :item_from_content_store

  def initialize(slug, item_from_content_store)
    @slug = slug
    @item_from_content_store = item_from_content_store
  end

  def lists
    @lists ||= ListSet.new("section", @slug, groups)
  end

private

  def groups
    (item_from_content_store.details && item_from_content_store.details.groups) || []
  end
end
