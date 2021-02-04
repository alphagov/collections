class ServicesAndInformationLinksGrouper
  def initialize(organisation_id)
    @organisation_id = organisation_id
  end

  def parsed_grouped_links
    grouped_links_from_search_api.map do |group|
      ServicesAndInformationGroup.new(group)
    end
  end

private

  def grouped_links_from_search_api
    @grouped_links_from_search_api ||= begin
      params = {
        count: "0",
        filter_organisations: @organisation_id,
        facet_specialist_sectors: "1000,examples:4,example_scope:query,order:value.title",
      }
      Services.cached_search(params)["facets"]["specialist_sectors"]["options"]
    end
  end
end
