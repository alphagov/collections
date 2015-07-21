require 'gds_api/test_helpers/content_api'
require 'gds_api/test_helpers/rummager'

require_relative '../../test/support/rummager_helpers'

module TopicHelper
  include GdsApi::TestHelpers::ContentApi
  include GdsApi::TestHelpers::Rummager
  include RummagerHelpers

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
end

World(TopicHelper)
