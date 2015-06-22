class SecondLevelBrowsePage
  attr_reader :top_level_slug, :second_level_slug

  delegate :curated_links?, :lists, to: :browse_page_content_item
  delegate :title, to: :content_store_item

  def initialize(top_level_slug, second_level_slug)
    @top_level_slug = top_level_slug
    @second_level_slug = second_level_slug
  end

  def slimmer_breadcrumb_options
    {
      title: "browse",
      section_name: active_top_level_browse_page.title,
      section_link: active_top_level_browse_page.web_url
    }
  end

  def related_topics
    RelatedTopicList.new(
      content_store_item,
      Collections.services(:detailed_guidance_content_api)
    ).related_topics_for("#{top_level_slug}/#{second_level_slug}")
  end

  def active_top_level_browse_page
    # Note that 'active_top_level_browse_page' will always have just one element.
    content_store_item.links.active_top_level_browse_page.first
  end

  def second_level_browse_pages
    content_store_item.links.second_level_browse_pages
  end

  def top_level_browse_pages
    content_store_item.links.top_level_browse_pages
  end

private

  def content_store_item
    @content_store_item ||= begin
      content_path = "/browse/#{top_level_slug}/#{second_level_slug}"
      Collections.services(:content_store).content_item!(content_path)
    end
  end

  def browse_page_content_item
    @browse_page_content_item ||= BrowsePageContentItem.new(
      "#{top_level_slug}/#{second_level_slug}",
      content_store_item
    )
  end
end
