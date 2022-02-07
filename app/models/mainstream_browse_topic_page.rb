class MainstreamBrowseTopicPage
  attr_reader :content_item

  delegate(
    :content_id,
    :base_path,
    :title,
    :description,
    :linked_items,
    :details,
    :to_hash,
    to: :content_item,
  )

  def self.find(base_path)
    content_item = ContentItem.find!(base_path)
    new(content_item)
  end

  def initialize(content_item)
    @content_item = content_item
  end

  def top_level_browse_pages
    # linked_items("top_level_browse_pages")
    # We could store all the top level topics on child topics to save this additional fetch.
    @top_level_browse_pages ||= ContentItem.find!("/topic").linked_items("children")

  end

  def active_top_level_browse_page
    linked_items("parent").first
  end

  def child_topic?
    linked_items("parent").any?
  end

  def siblings
    me = ContentItem.find!(slug.gsub("browsetopics", "topic"))
    p = me.linked_items("parent").first
    path = p.base_path.gsub("browsetopics", "topic")
    parent = ContentItem.find!(path)
    parent.linked_items("children")
  end

  def second_level_browse_pages
    links = linked_items("children")

    if second_level_pages_curated?
      links.sort_by do |link|
        details["ordered_second_level_browse_pages"].index(link.content_id)
      end
    else
      links
    end
  end

  def second_level_pages_curated?
    #not present on the topic content item, so would need to be added.
    # details["second_level_ordering"] == "curated"
    false
  end

  def lists
    @lists ||= ListSet.new("section", @content_item.content_id, details["groups"])
  end

  def related_topics
    linked_items("related_topics")
  end

  def slug
    base_path
  end
end
