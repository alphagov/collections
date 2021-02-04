module OrganisationFeedHelpers
  def stub_content_for_organisation_feed(organisation, results)
    params = {
      start: 0,
      count: 20,
      fields: %w[title link description display_type public_timestamp],
      filter_organisations: organisation,
      reject_content_purpose_supergroup: "other",
      order: "-public_timestamp",
    }

    Services.search_api.stubs(:search)
      .with(params)
      .returns(
        "results" => results,
        "start" => 0,
        "total" => results.size,
      )
  end

  def stub_empty_results
    Services.search_api.stubs(:search)
      .returns(
        "results" => [],
        "start" => 0,
        "total" => 0,
      )
  end
end
