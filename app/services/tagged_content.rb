class TaggedContent
  attr_reader :content_ids, :filter_by_document_supertype, :validate

  def initialize(content_ids, filter_by_document_supertype:, validate:)
    @content_ids = Array(content_ids)
    @filter_by_document_supertype = filter_by_document_supertype
    @validate = validate
  end

  def self.fetch(content_ids, filter_by_document_supertype:, validate:)
    new(content_ids, filter_by_document_supertype: filter_by_document_supertype, validate: validate).fetch
  end

  def fetch
    documents = search_response.documents
    documents = documents.select { |document| tagged_content_validator.valid?(document) } if validate
    documents
  end

private

  def tagged_content_validator
    @tagged_content_validator ||= TaggedContentValidator.new
  end

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
