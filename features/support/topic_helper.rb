require 'gds_api/test_helpers/rummager'
require 'slimmer/test_helpers/govuk_components'

require_relative '../../test/support/rummager_helpers'

module TopicHelper
  include GdsApi::TestHelpers::Rummager
  include RummagerHelpers
  include Slimmer::TestHelpers::GovukComponents

  def stub_topic_lookups
    @organisations = %w{
      government/organisations/department-of-energy-climate-change
      government/organisations/air-accidents-investigation-branch
    }

    rummager_has_documents_for_subtopic(
      'content-id-for-fields-and-wells',
      %w{
        what-is-oil
        apply-for-an-oil-licence
        environmental-policy
        onshore-exploration-and-production
        well-application-form
        well-report-2014
        oil-extraction-count-2013
      },
      page_size: RummagerSearch::PAGE_SIZE_TO_GET_EVERYTHING
    )

    content_store_has_item("/topic/oil-and-gas/fields-and-wells",
      content_id: 'content-id-for-fields-and-wells',
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
            ]
          },
          {
            name: "Piping",
            contents: [
              "/well-application-form",
            ]
          },
        ],
      },
      links: {
        "parent" => [
          "title" => "Oil and Gas",
          "base_path" => "/oil-and-gas",
        ]
      })

    stub_topic_organisations(
      'oil-and-gas/fields-and-wells',
      'content-id-for-fields-and-wells'
    )

    stub_shared_component_locales
  end
end

World(TopicHelper)
