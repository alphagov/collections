class RummagerSearch
  PAGE_SIZE_TO_GET_EVERYTHING = 1000

  GUIDANCE_DOCUMENT_TYPES = %w[
    answer
    contact
    detailed_guide
    document_collection
    form
    guidance
    guide
    licence
    local_transaction
    manual
    map
    notice
    place
    programme
    promotional
    regulation
    simple_smart_answer
    smart_answer
    statutory_guidance
    transaction
    travel_advice
  ].freeze

  include Enumerable
  delegate :each, to: :documents

  def initialize(search_params)
    @search_params = search_params
  end

  def documents
    @_documents ||= search_result["results"].map do |result|
      timestamp = result["public_timestamp"].present? ? Time.parse(result["public_timestamp"]) : nil
      Document.new(
        result["title"],
        result["description"],
        result["link"],
        timestamp,
        result["latest_change_note"],
        result["format"],
      )
    end
  end

  def total
    search_result["total"]
  end

  def start
    search_result["start"]
  end

private

  def search_result
    @_search_result ||= Services.rummager.search(@search_params)
  end

  Document = Struct.new(
    :title,
    :description,
    :base_path,
    :public_updated_at,
    :change_note,
    :format
  )
end
