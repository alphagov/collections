class TaggedContent
  attr_reader :content_id

  def initialize(content_id)
    @content_id = content_id
  end

  def self.fetch(content_id)
    new(content_id).fetch
  end

  def fetch
    search_response
      .documents
      .select { |document| tagged_content_validator.valid?(document) }
  end

private

  def tagged_content_validator
    @tagged_content_validator ||= TaggedContentValidator.new
  end

  def search_response
    RummagerSearch.new(
      start: 0,
      count: RummagerSearch::PAGE_SIZE_TO_GET_EVERYTHING,
      fields: %w(title description link document_collections content_store_document_type),
      filter_content_store_document_type: GovukNavigationHelpers::Guidance::DOCUMENT_TYPES,
      filter_taxons: [content_id],
      order: 'title',
    )
  end
end
