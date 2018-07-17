module Feeds
  class OrganisationFeedContent
    attr_reader :organisation

    def initialize(organisation:)
      @organisation = organisation
    end

    def self.fetch(organisation:)
      new(organisation: organisation).fetch
    end

    def fetch
      search_response
    end

  private

    def search_response
      params = {
        start: 0,
        count: 20,
        fields: RummagerFields::FEED_SEARCH_FIELDS,
        filter_organisations: organisation,
        reject_content_purpose_supergroup: "other",
        order: '-public_timestamp',
      }

      Services.rummager.search(params)
    end
  end
end
