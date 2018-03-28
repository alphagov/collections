class TaggedContent
  attr_reader :content_ids, :filter_by_document_supertype, :validate

  def initialize(content_ids, filter_by_document_supertype:)
    @content_ids = Array(content_ids)
    @filter_by_document_supertype = filter_by_document_supertype
  end

  def self.fetch(content_ids, filter_by_document_supertype:)
    new(content_ids, filter_by_document_supertype: filter_by_document_supertype).fetch
  end

  def fetch
    search_response.documents
  end

private

  def search_response
    params = {
      start: 0,
      count: RummagerSearch::PAGE_SIZE_TO_GET_EVERYTHING,
      fields: %w(title description link document_collections content_store_document_type),
      filter_taxons: content_ids,
      order: 'title',
    }
    params[:filter_navigation_document_supertype] = filter_by_document_supertype if filter_by_document_supertype.present?

    RummagerSearch.new(params)
  end
end
