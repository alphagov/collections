require "gds_api/test_helpers/content_store"
require "gds_api/test_helpers/search"
require_relative "../../spec/support/search_api_helpers"

module TestHelpers
  include GdsApi::TestHelpers::Search
  include GdsApi::TestHelpers::ContentStore
  include SearchApiHelpers
end

module TopicHelper
  def subtopic_slugs
    %w[
      what-is-oil
      apply-for-an-oil-licence
      environmental-policy
      onshore-exploration-and-production
      well-application-form
      well-report-2014
      oil-extraction-count-2013
    ]
  end

  def stub_topic_lookups
    search_api_has_documents_for_subtopic(
      "content-id-for-fields-and-wells",
      subtopic_slugs,
      page_size: SearchApiSearch::PAGE_SIZE_TO_GET_EVERYTHING,
    )

    stub_content_store_has_item(
      "/topic/oil-and-gas/fields-and-wells",
      content_id: "content-id-for-fields-and-wells",
      base_path: "/topic/oil-and-gas/fields-and-wells",
      title: "Fields and Wells",
      format: "topic",
      public_updated_at: 10.days.ago.iso8601,
      details: {
        groups: [
          {
            name: "Oil rigs",
            content_ids: %w[
              what-is-oil-content-id
              apply-for-an-oil-licence-content-id
            ],
          },
          {
            name: "Piping",
            content_ids: %w[
              well-application-form-content-id
            ],
          },
        ],
      },
      links: {
        "parent" => [
          "title" => "Oil and Gas",
          "base_path" => "/oil-and-gas",
        ],
      },
    )

    stub_topic_organisations(
      "oil-and-gas/fields-and-wells",
      "content-id-for-fields-and-wells",
    )
  end

  def stub_latest_changes
    search_api_has_latest_documents_for_subtopic("content-id-for-fields-and-wells", subtopic_slugs)
  end
end

World(TestHelpers, TopicHelper)
