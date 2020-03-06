require "gds_api/test_helpers/search"
require_relative "../../test/support/rummager_helpers"

module TopicHelper
  include GdsApi::TestHelpers::Search
  include RummagerHelpers

  def stub_topic_lookups
    rummager_has_documents_for_subtopic(
      "content-id-for-fields-and-wells",
      %w{
        what-is-oil
        apply-for-an-oil-licence
        environmental-policy
        onshore-exploration-and-production
        well-application-form
        well-report-2014
        oil-extraction-count-2013
      },
      page_size: RummagerSearch::PAGE_SIZE_TO_GET_EVERYTHING,
    )

    stub_content_store_has_item("/topic",
      content_id: "topics",
      base_path: "/topic",
      title: "Topics",
      document_type: "topic",
      public_updated_at: 10.days.ago.iso8601,
      details: {
        internal_name: "Topic index page",
      },
      links: {
        "children" => [
          "title" => "Oil and Gas",
          "base_path" => "/topic/oil-and-gas",
        ],
      },
    )
    stub_content_store_has_item("/topic/oil-and-gas",
      content_id: "/topic/oil-and-gas",
      base_path: "/topic/oil-and-gas",
      title: "Oil and gas",
      document_type: "topic",
      public_updated_at: 10.days.ago.iso8601,
      details: {
        "groups": [],
        "internal_name": "Oil and gas"
      },
      links: {
        "children" => [
          "title" => "Fields and wells",
          "base_path" => "/topic/oil-and-gas/fields-and-wells",
        ],
      },
    )

    stub_content_store_has_item("/topic/oil-and-gas/fields-and-wells",
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
                                })

    stub_topic_organisations(
      "oil-and-gas/fields-and-wells",
      "content-id-for-fields-and-wells",
    )
  end
end

World(TopicHelper)
