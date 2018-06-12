module OrganisationFeedHelpers
  def stub_content_for_feed(organisation, results)
    params = {
      start: 0,
      count: 20,
      fields: %w(title link description display_type public_timestamp),
      filter_organisations: organisation,
      reject_email_document_supertype: "other",
      order: '-public_timestamp',
    }

    Services.rummager.stubs(:search)
      .with(params)
      .returns(
        "results" => results,
        "start" => 0,
        "total" => results.size,
      )
  end

  def stub_empty_results
    Services.rummager.stubs(:search)
      .returns(
        "results" => [],
        "start" => 0,
        "total" => 0,
      )
  end
end
