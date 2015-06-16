class IndexBrowsePage
  def top_level_browse_pages
    Collections.services(:content_api).root_sections.results.sort_by(&:title)
  end

  def slimmer_breadcrumb_options
    {
      title: "browse",
      section_name: "Browse",
      section_link: "/browse"
    }
  end
end
