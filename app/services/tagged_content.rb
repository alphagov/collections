class TaggedContent
  attr_reader :content_id

  def initialize(content_id)
    @content_id = content_id
  end

  def self.fetch(content_id)
    new(content_id).fetch
  end

  def fetch
    RummagerSearch.new(
      start: 0,
      count: RummagerSearch::PAGE_SIZE_TO_GET_EVERYTHING,
      fields: %w(title description link document_collections content_store_document_type),
      filter_content_store_document_type: GovukNavigationHelpers::Guidance::DOCUMENT_TYPES,
      filter_taxons: [content_id],
      order: 'title',
    ).documents
  end
end
