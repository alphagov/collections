class ServicesAndInformationLinksGrouper
  def initialize(organisation_id)
    @organisation_id = organisation_id
  end

  def parsed_grouped_links
    grouped_links_from_rummager.map do |group|
      ServicesAndInformationGroup.new(group)
    end
  end

private

  def grouped_links_from_rummager
    Services.rummager.search(
      count: "0",
      filter_organisations: @organisation_id,
      facet_specialist_sectors: "1000,examples:4,example_scope:query,order:value.title",
    ).to_hash["facets"]["specialist_sectors"]["options"]
  end
end
