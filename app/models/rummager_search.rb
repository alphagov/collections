class RummagerSearch
  PAGE_SIZE_TO_GET_EVERYTHING = 1000

  include Enumerable
  delegate :each, to: :documents

  def initialize(search_params)
    @search_params = search_params
  end

  def documents
    @_documents ||= search_result["results"].map do |result|
      timestamp = result["public_timestamp"].present? ? Time.parse(result["public_timestamp"]) : nil
      Document.new(
        title: result["title"],
        description: result["description"],
        base_path: result["link"],
        public_updated_at: timestamp,
        change_note: result["latest_change_note"],
        format: result["format"],
        document_collections: result["document_collections"],
        content_store_document_type: result['content_store_document_type']
      )
    end
  end

  def total
    search_result["total"]
  end

  def start
    search_result["start"]
  end

  def organisations
    @_organisations ||= search_result.dig('aggregates', 'organisations', 'options').map do |option|
      organisation = option['value']
      Organisation.new(
        title: organisation['title'],
        content_id: organisation['content_id'],
        link: organisation['link'],
        slug: organisation['slug'],
        organisation_state: organisation['organisation_state'],
        document_count: option['documents']
      )
    end
  end

private

  def search_result
    @_search_result ||= Services.rummager.search(@search_params)
  end
end
