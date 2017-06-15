class TaggedContent
  attr_reader :content_ids

  def initialize(content_ids)
    @content_ids = Array(content_ids)
  end

  def self.fetch(content_ids)
    new(content_ids).fetch
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
      filter_navigation_document_supertype: 'guidance',
      filter_taxons: content_ids,
      order: 'title',
    )
  end
end
