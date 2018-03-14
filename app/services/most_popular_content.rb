class MostPopularContent
  attr_reader :content_id, :filter_content_purpose_supergroup, :number_of_links

  def initialize(content_id:, filter_content_purpose_supergroup:, number_of_links: 5)
    @content_id = content_id
    @filter_content_purpose_supergroup = filter_content_purpose_supergroup
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
    search_fields = %w(title
                       link
                       description
                       content_store_document_type
                       public_timestamp
                       organisations)
    params = {
      start: 0,
      count: number_of_links,
      fields: search_fields,
      filter_taxons: Array(content_id),
      order: '-popularity',
    }
    params[:filter_content_purpose_supergroup] = filter_content_purpose_supergroup if filter_content_purpose_supergroup.present?

    RummagerSearch.new(params)
  end
end
