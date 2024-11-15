class PopularListSet
  def initialize(content_item)
    @content_item = content_item
  end

  def self.fetch(content_item)
    new(content_item).formatted_results
  end

  def formatted_results
    if search_response["results"].present?
      search_response["results"].map do |result|
        {
          title: result["title"],
          link: result["link"],
        }
      end
    end
  end

private

  attr_reader :content_item

  def search_response
    params = {
      filter_any_mainstream_browse_page_content_ids: second_level_browse_content_ids,
      count: 3,
      order: "-popularity",
      fields: SearchApiFields::POPULAR_BROWSE_SEARCH_FIELDS,
    }
    Services.cached_search(params)
  end

  def second_level_browse_content_ids
    content_item
      .linked_items("second_level_browse_pages")
      .map { |content_item| content_item.content_item_data["content_id"] }
  end
end
