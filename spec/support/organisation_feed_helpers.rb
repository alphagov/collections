module OrganisationFeedHelpers
  include SearchApiHelpers

  def stub_content_for_organisation_feed(organisation, results)
    params = {
      start: "0",
      count: "20",
      fields: webmock_match_array(%w[title link description display_type public_timestamp]),
      filter_organisations: organisation,
      reject_content_purpose_supergroup: "other",
      order: "-public_timestamp",
    }
    body = {
      "results" => results,
      "start" => 0,
      "total" => results.size,
    }
    stub_search(params: params, body: body)
  end

  def stub_empty_results
    body = {
      "results" => [],
      "start" => 0,
      "total" => 0,
    }
    stub_search(body: body)
  end
end
