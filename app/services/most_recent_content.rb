class MostRecentContent
  include SearchApiFields

  attr_reader :content_id, :filter_content_store_document_type, :number_of_links

  def initialize(content_id:, filter_content_store_document_type:, number_of_links: 5)
    @content_id = content_id
    @filter_content_store_document_type = filter_content_store_document_type
    @number_of_links = number_of_links
  end

  def self.fetch(content_id:, filter_content_store_document_type:)
    new(content_id: content_id, filter_content_store_document_type: filter_content_store_document_type).fetch
  end

  def fetch
    search_response.documents
  end

private

  def search_response
    params = {
      start: 0,
      count: number_of_links,
      fields: SearchApiFields::TAXON_SEARCH_FIELDS,
      filter_part_of_taxonomy_tree: [content_id],
      order: "-public_timestamp",
      filter_content_store_document_type: filter_content_store_document_type,
    }

    SearchApiSearch.new(params)
  end
end
