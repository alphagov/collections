class MostPopularContent
  attr_reader :content_id, :number_of_links

  def initialize(content_id:, number_of_links: 5)
    @content_id = content_id
    @number_of_links = number_of_links
  end

  def self.fetch(content_id:)
    new(content_id: content_id).fetch
  end

  def fetch
    search_response
      .documents
      .sort_by(&:title)
  end

private

  def search_response
    RummagerSearch.new(
      start: 0,
      count: number_of_links,
      fields: %w(title link),
      filter_navigation_document_supertype: 'guidance',
      filter_part_of_taxonomy_tree: content_id,
      order: '-popularity',
    )
  end
end
