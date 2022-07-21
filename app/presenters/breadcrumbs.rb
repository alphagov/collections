# Breadcrumbs for Mainstream browse and old topic pages
class Breadcrumbs
  include TopicBrowseHelper

  def initialize(content_item, request)
    @content_item = content_item
    @request = request
  end

  def breadcrumbs
    ordered_parents = parent_selector.map do |parent|
      { title: parent.fetch("title"), url: parent.fetch("base_path") }
    end

    ordered_parents << { title: I18n.t("shared.breadcrumbs_home"), url: "/" }

    ordered_parents.reverse
  end

private

  attr_reader :content_item, :request

  def all_parents
    parents = []

    direct_parent = content_item.dig("links", "parent", 0)
    while direct_parent
      parents << direct_parent

      direct_parent = direct_parent.dig("links", "parent", 0)
    end

    parents
  end

  def topic_browse_breadcrumb
    mapping = topic_as_browse_mapping(request)
    return if mapping.blank?
    
    page = MainstreamBrowsePage.find(mapping["browse_path"])
    [{ "title" => page.title, "base_path" => page.base_path }]
  end

  def parent_selector
    topic_browse_breadcrumb.presence || all_parents
  end
end
