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

    content_item = {
      base_path: "/topic/oil-and-gas/fields-and-wells",
      format: "topic",
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
        parent: [
          content_link("Oil and Gas", "/oil-and-gas")
        ],
        topic_content: [
          content_link("What is oil", "/what-is-oil"),
          content_link("Apply for an oil licence", "/apply-for-an-oil-licence"),
          content_link("Environmental policy", "/environmental-policy"),
          content_link("Onshore exploration and production", "/onshore-exploration-and-production"),
          content_link("Well application form", "/well-application-form"),
          content_link("Well report 2014", "/well-report-2014"),
          content_link("Oil extraction count 2013", "/oil-extraction-count-2013"),
        ]
      }
    }

    topic = GovukSchemas::RandomExample
      .for_schema(frontend_schema: 'topic')
      .merge_and_validate(content_item)
    content_store_has_item("/topic/oil-and-gas/fields-and-wells", topic)

    stub_topic_organisations(
      'oil-and-gas/fields-and-wells',
      topic["content_id"]
    )

    stub_shared_component_locales

    topic["content_id"]
  end

private

  def content_link(title, base_path)
    {
      title: title,
      base_path: base_path,
      locale: "en",
      content_id: SecureRandom::uuid
    }
  end
end

World(TopicHelper)
