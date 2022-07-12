class MainstreamBrowsePage
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
    linked_items("top_level_browse_pages")
  end

  def active_top_level_browse_page
    linked_items("parent").first
  end

  def second_level_browse_pages
    if base_path == "/browse/tax"
      mainstream_browse_children << specialist_subtopic
    else
      mainstream_browse_children
    end
  end

  def mainstream_browse_children
    links = linked_items("children")

    if second_level_pages_curated?
      links.sort_by do |link|
        details["ordered_second_level_browse_pages"].index(link.content_id)
      end
    else
      links
    end
  end

  def specialist_subtopic
    topic = Topic.find("/topic/benefits-credits/tax-credits")
  end

  def second_level_pages_curated?
    details["second_level_ordering"] == "curated"
  end

  def lists
    @lists ||= ListSet.new("section", @content_item.content_id, details["groups"])
  end

  def related_topics
    linked_items("related_topics")
  end

  def slug
    base_path.sub(%r{\A/browse/}, "")
  end
end
