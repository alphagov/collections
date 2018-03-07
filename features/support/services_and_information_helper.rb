require 'gds_api/test_helpers/rummager'
require 'slimmer/test_helpers/govuk_components'

require_relative '../../test/support/rummager_helpers'

module ServicesAndInformationHelpers
  include GdsApi::TestHelpers::Rummager
  include RummagerHelpers
  include Slimmer::TestHelpers::GovukComponents

  def stub_services_and_information_lookups
    @services_and_information = %w{
      environmental-permit-check-if-you-need-one
      government/publications/environmental-permitting-ep-charges-scheme-april-2014-to-march-2015
      hazardous-waste-producer-registration
    }

    stub_services_and_information_links("hm-revenue-customs")

    content_store_has_item("/government/organisations/hm-revenue-customs/services-information",
      content_id: 'content-id-for-hm-revenue-customs-services-information',
      base_path: "/government/organisations/hm-revenue-customs/services-information",
      title: "Services and information - HM Revenue & Customs",
      format: "services_and_information",
      public_updated_at: 10.days.ago.iso8601,
      details: {},
      links: {
        "parent" => [
          "title" => "HM Revenue & Customs",
          "base_path" => "/government/organisations/hm-revenue-customs",
        ]
      },)

    stub_shared_component_locales
  end
end

World(ServicesAndInformationHelpers)
