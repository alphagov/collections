require 'gds_api/test_helpers/content_api'
require 'gds_api/test_helpers/rummager'

module TopicHelper
  include GdsApi::TestHelpers::ContentApi
  include GdsApi::TestHelpers::Rummager

  def stub_topic_lookups
    @organisations = %w{
      government/organisations/department-of-energy-climate-change
      government/organisations/air-accidents-investigation-branch
    }

    rummager_has_documents_for_subtopic(
      "oil-and-gas/fields-and-wells",
      %w{
        what-is-oil
        apply-for-an-oil-licence
        environmental-policy
        onshore-exploration-and-production
        well-application-form
        well-report-2014
        oil-extraction-count-2013
      }
    )

    content_store_has_item("/topic/oil-and-gas/fields-and-wells", {
      base_path: "/topic/oil-and-gas/fields-and-wells",
      title: "Fields and Wells",
      format: "topic",
      public_updated_at: 10.days.ago.iso8601,
      details: {
        groups: [
          {
            name: "Oil rigs",
            contents: [
              "http://example.com/what-is-oil.json",
              "http://example.com/apply-for-an-oil-licence.json",
            ]
          },
          {
            name: "Piping",
            contents: [
              "http://example.com/well-application-form.json",
            ]
          },
        ],
      },
      links: {
        "parent" => [
          "title" => "Oil and Gas",
          "base_path" => "/oil-and-gas",
        ]
      },
    })

    stub_topic_organisations("oil-and-gas/fields-and-wells")
  end

  def stub_topic_organisations(slug)
    Collections::Application.config.search_client.stubs(:unified_search).with(
      count: "0",
      filter_specialist_sectors: [slug],
      facet_organisations: "1000",
    ).returns(
      rummager_has_specialist_sector_organisations(slug)
    )
  end

  def rummager_has_documents_for_subtopic(subtopic_slug, document_slugs, format = "guide", page_size: 50)
    results = document_slugs.map.with_index do |slug, i|
      rummager_document_for_slug(slug, (i + 1).hours.ago, format)
    end

    results.each_slice(page_size).with_index do |results_page, page|
      start = page * page_size
      Collections::Application.config.search_client.stubs(:unified_search).with(
        has_entries(
          start: start,
          count: page_size,
          filter_specialist_sectors: [subtopic_slug],
        )
      ).returns({
        "results" => results_page,
        "start" => start,
        "total" => results.size,
      })
    end
  end

  def rummager_document_for_slug(slug, updated_at = 1.hour.ago, format = "guide")
    {
      "format" => "#{format}",
      "latest_change_note" => "This has changed",
      "public_timestamp" => updated_at.iso8601,
      "title" => "#{slug.titleize.humanize}",
      "link" => "/#{slug}",
      "index" => "/",
      "_id" => "/#{slug}",
      "document_type" => "edition"
    }
  end
end

World(TopicHelper)
