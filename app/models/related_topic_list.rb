# FIXME: Once the content has been migrated to content store, remove whitehall code.
class RelatedTopicList
  def initialize(content_item, whitehall)
    @content_item = content_item
    @whitehall = whitehall
  end

  def related_topics_for(path)
    fetch_results_for_path(path).sort_by(&:title)
  end

  private

  def fetch_results_for_path(path)
    results = @content_item.try(:links).try(:related_topics).to_a

    if results.any?
      results
    else
      legacy_fallback_to_whitehall(path)
    end
  rescue GdsApi::HTTPNotFound, GdsApi::HTTPGone
    []
  end

  def legacy_fallback_to_whitehall(path)
    response = @whitehall.sub_sections(path)

    response.results.map do |detailed_guide_category|
      OpenStruct.new(
        title: detailed_guide_category.title,
        web_url: detailed_guide_category.content_with_tag.web_url
      )
    end
  end
end
