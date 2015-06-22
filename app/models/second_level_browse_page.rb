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
    Collections.services(:content_api).tag(top_level_slug) || raise(GdsApi::HTTPNotFound, 404)
  end

  def second_level_browse_pages
    Collections.services(:content_api).sub_sections(top_level_slug).results.sort_by(&:title)
  end

  def top_level_browse_pages
    Collections.services(:content_api).root_sections.results.sort_by(&:title)
  end

private

  def content_store_item
    @content_store_item ||= Collections.services(:content_store).content_item!(
      "/browse/#{top_level_slug}/#{second_level_slug}"
    )
  end
  
  def browse_page_content_item
    @browse_page_content_item ||= BrowsePageContentItem.new(
      "#{top_level_slug}/#{second_level_slug}",
      content_store_item
    )
  end
end
