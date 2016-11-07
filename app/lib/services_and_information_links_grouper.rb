class ServicesAndInformationLinksGrouper
  def initialize(organisation_id)
    @organisation_id = organisation_id
  end

  def parsed_grouped_links
    grouped_links_from_rummager.map do |group|
      {
        "title" => group["value"]["title"],
        "examples" => group["value"]["example_info"]["examples"],
        "document_count" => group["value"]["example_info"]["total"],
        "subsector_link" => group["value"]["link"],
        "more_documents" => more_documents?(group),
      }
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

  def more_documents?(group)
    # Check if there are more documents than are being shown
    group["value"]["example_info"]["total"] > group["value"]["example_info"]["examples"].count
  end
end
