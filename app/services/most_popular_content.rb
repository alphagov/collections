class MostPopularContent
  include RummagerFields

  attr_reader :search_params

  def initialize(search_params)
    @search_params = search_params
  end

  def self.fetch(search_params)
    new(search_params).fetch
  end

  def fetch
    search_response
      .documents
  end

private

  def search_response
    params = {
      start: 0,
      count: 5,
      fields: RummagerFields::TAXON_SEARCH_FIELDS,
      order: '-popularity',
    }.merge(search_params)

    RummagerSearch.new(params)
  end
end
