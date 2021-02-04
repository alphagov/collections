class TaggedContent
  attr_reader :content_ids, :validate

  def initialize(content_ids)
    @content_ids = Array(content_ids)
  end

  def self.fetch(content_ids)
    new(content_ids).fetch
  end

  def fetch
    search_response.documents
  end

private

  def search_response
    params = {
      start: 0,
      count: SearchApiSearch::PAGE_SIZE_TO_GET_EVERYTHING,
      fields: %w[title description link content_store_document_type],
      filter_taxons: content_ids,
      order: "title",
    }

    SearchApiSearch.new(params)
  end
end
