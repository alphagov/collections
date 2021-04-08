require "gds_api/test_helpers/content_item_helpers"

module TaxonHelpers
  include GdsApi::TestHelpers::ContentItemHelpers
  # This taxon has grandchildren
  def funding_and_finance_for_students_taxon(params = {})
    fetch_and_validate_taxon(:funding_and_finance_for_students, params)
  end

  # This taxon does not have grandchildren
  def student_finance_taxon(params = {})
    fetch_and_validate_taxon(:student_finance, params)
  end

  def student_sponsorship_taxon(params = {})
    fetch_and_validate_taxon(:student_sponsorship, params)
  end

  def student_loans_taxon(params = {})
    fetch_and_validate_taxon(:student_loans, params)
  end

  def world_usa_taxon(params = {})
    fetch_and_validate_taxon(:world_usa, params)
  end

  def world_usa_news_events_taxon(params = {})
    fetch_and_validate_taxon(:world_usa_news_events, params)
  end

  # This taxon has an associated_taxon
  def travelling_to_the_usa_taxon(params = {})
    fetch_and_validate_taxon(:travelling_to_the_usa, params)
  end

  def taxon
    GovukSchemas::Example.find("taxon", example_name: "taxon").tap do |content_item|
      content_item["phase"] = "live"
    end
  end

  def tagged_content_for_services
    @tagged_content_for_services ||= generate_search_results(2, "services")
  end

  def tagged_content_for_guidance_and_regulation
    @tagged_content_for_guidance_and_regulation ||= generate_search_results(2, "guidance_and_regulation")
  end

  def tagged_content_for_news_and_communications
    @tagged_content_for_news_and_communications ||= generate_search_results(2, "news_and_communications")
  end

  def tagged_content_for_policy_and_engagement
    @tagged_content_for_policy_and_engagement ||= generate_search_results(2, "policy_and_engagement")
  end

  def tagged_content_for_transparency
    @tagged_content_for_transparency ||= generate_search_results(2, "transparency")
  end

  def tagged_content_for_research_and_statistics
    @tagged_content_for_research_and_statistics ||= generate_search_results(2, "research_and_statistics")
  end

  def tagged_organisations
    [
      tagged_organisation,
      tagged_organisation_with_logo,
    ]
  end

  def tagged_organisation
    {
      "value" => {
        "title" => "Organisation without logo",
        "link" => "/government/organisations/organisation-without-logo",
        "organisation_state" => "live",
      },
    }
  end

  def tagged_organisation_with_logo
    {
      "value" => {
        "title" => "Organisation with logo",
        "link" => "/government/organisations/organisation-with-logo",
        "organisation_state" => "live",
        "organisation_brand" => "org-brand",
        "organisation_crest" => "single-identity",
        "logo_formatted_title" => "organisation-with-logo",
      },
    }
  end

private

  def fetch_and_validate_taxon(basename, params = {})
    json = File.read(
      Rails.root.join("spec", "fixtures", "content_store", "#{basename}.json"),
    )
    content_item = JSON.parse(json)

    GovukSchemas::RandomExample.for_schema(frontend_schema: "taxon") do |payload|
      payload.merge(content_item.merge(params))
    end
  end
end
