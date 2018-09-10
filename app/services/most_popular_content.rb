class MostPopularContent
  include RummagerFields

  attr_reader :content_id, :filter_content_purpose_supergroup, :number_of_links

  def initialize(content_id:, filter_content_purpose_supergroup:, number_of_links: 5)
    @content_id = content_id
    @filter_content_purpose_supergroup = Array(filter_content_purpose_supergroup).reject(&:blank?)
    @number_of_links = number_of_links
  end

  def self.fetch(content_id:, filter_content_purpose_supergroup:)
    new(content_id: content_id, filter_content_purpose_supergroup: filter_content_purpose_supergroup).fetch
  end

  def fetch
    search_response
      .documents
  end

private

  def search_response
    params = {
      start: 0,
      count: number_of_links,
      fields: RummagerFields::TAXON_SEARCH_FIELDS,
      filter_part_of_taxonomy_tree: Array(content_id),
      order: '-popularity',
    }
    params[:filter_content_purpose_supergroup] = filter_content_purpose_supergroup if filter_content_purpose_supergroup.present?

    RummagerSearch.new(params)
  end
end
