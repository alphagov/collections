class OrganisationFeedContent
  include RummagerFields

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
      #using this as providing a list of the currently supported types is too big.
      #email_document_supertype seems to fit with the ethos of what we're trying to
      #provide.
      reject_email_document_supertype: "other",
      order: '-public_timestamp',
    }

    Services.rummager.search(params)
  end
end
