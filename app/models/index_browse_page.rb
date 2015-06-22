class IndexBrowsePage
  def top_level_browse_pages
    content_store_item.links.top_level_browse_pages
  end

  def slimmer_breadcrumb_options
    {
      title: "browse",
      section_name: "Browse",
      section_link: "/browse"
    }
  end

private

  def content_store_item
    @content_store_item ||= begin
      Collections.services(:content_store).content_item!('/browse')
    end
  end
end
