class TaggedOrganisations
  attr_reader :content_ids

  def initialize(content_ids)
    @content_ids = Array(content_ids)
  end

  def self.fetch(content_ids)
    new(content_ids).fetch
  end

  def fetch
    organisations = search_response.organisations
    organisations.keep_if(&:live?)
  end

private

  def search_response
    params = {
      count: 0,
      aggregate_organisations: SearchApiSearch::PAGE_SIZE_TO_GET_EVERYTHING,
      filter_part_of_taxonomy_tree: content_ids,
    }

    SearchApiSearch.new(params)
  end
end
