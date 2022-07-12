class Topic
  attr_reader :content_item

  delegate(
    :base_path,
    :title,
    :description,
    :content_id,
    :linked_items,
    :details,
    :to_hash,
    to: :content_item,
  )

  def self.find(base_path, pagination_options = {})
    content_item = ContentItem.find!(base_path)
    new(content_item, pagination_options)
  end

  def initialize(content_item, pagination_options = {})
    @content_item = content_item
    @pagination_options = pagination_options
  end

  def parent
    linked_items("parent").first
  end

  def active_top_level_browse_page
    linked_items("parent").first
  end

  def children
    linked_items("children")
  end

  def combined_title
    if parent
      "#{parent.title}: #{title} - detailed information"
    else
      "#{title}: detailed information"
    end
  end

  def lists
    @lists ||= ListSet.new("specialist_sector", content_item.content_id, details["groups"])
  end

  def related_topics
    []
  end

  def changed_documents
    @changed_documents ||= ChangedDocuments.new(content_item.content_id, @pagination_options)
  end

  def slug
    base_path.sub(%r{\A/topic/}, "")
  end
end
