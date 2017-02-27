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
    to: :content_item
  )

  DOCUMENT_TYPES_TO_EXCLUDE = %w(
    fatality_notice
    news_article
    speech
    world_location_news_article
  ).to_set

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

  def children
    linked_items("children")
  end

  def combined_title
    if parent
      "#{parent.title}: #{title}"
    else
      title
    end
  end

  def lists
    ListSet.new(
      @content_item.linked_items("topic_content"),
      details["groups"],
      DOCUMENT_TYPES_TO_EXCLUDE)
  end

  def changed_documents
    ChangedDocuments.new(content_item.content_id, @pagination_options)
  end

  def slug
    base_path.sub(%r{\A/topic/}, '')
  end
end
