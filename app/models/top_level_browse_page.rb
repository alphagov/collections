class TopLevelBrowsePage
  attr_reader :slug

  delegate :title, to: :item_in_content_api

  def initialize(slug)
    @slug = slug
  end

  def slimmer_breadcrumb_options
    {}
  end

  def second_level_browse_pages
    Collections.services(:content_api).sub_sections(slug).results.sort_by(&:title)
  end

  def top_level_browse_pages
    Collections.services(:content_api).root_sections.results.sort_by(&:title)
  end

private

  def item_in_content_api
    @source ||= Collections.services(:content_api).tag(slug) || raise(GdsApi::HTTPNotFound, 404)
  end
end
