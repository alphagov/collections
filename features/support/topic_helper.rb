require "gds_api/test_helpers/search"
require_relative "../../test/support/search_api_helpers"
require "gds_api/test_helpers/content_store"

module TopicHelper
  include GdsApi::TestHelpers::Search
  include GdsApi::TestHelpers::ContentStore
  include SearchApiHelpers

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
            contents: [
              "/what-is-oil",
              "/apply-for-an-oil-licence",
            ],
          },
          {
            name: "Piping",
            contents: [
              "/well-application-form",
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

World(TopicHelper)
