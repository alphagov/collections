class LocationLookupService
  attr_reader :postcode

  LOWER_TIER_AREA_CODES = %w[COI LBO LGD MTD UTA DIS].freeze

  def initialize(postcode)
    @postcode = postcode
  end

  def data
    return [] if error

    location_data = areas.map do |_, area|
      location = MapitPostcodeResponse.new(area)
      location if location.gss
    end

    location_data.compact
  end

  def postcode_not_found?
    (error && error[:code] == 404)
  end

  def invalid_postcode?
    error && error[:code] == 400
  end

  def no_information?
    error.blank? && data.blank?
  end

  def error
    response[:error]
  end

  def lower_tier_area_name
    lower_tier = data.select { |d| d.area_type.in?(LOWER_TIER_AREA_CODES) }
    lower_tier.first.area_name
  end

private

  def areas
    return [] if response.blank?

    response["response"].select { |data| data.first == "areas" }.first.last
  end

  def response
    @response ||= begin
                    Rails.cache.fetch("mapit-location-#{postcode}", expires_in: 3.hours) do
                      JSON.parse(mapit.location_for_postcode(postcode).to_json)
                    end
                  rescue GdsApi::HTTPNotFound, GdsApi::HTTPClientError => e
                    {
                      error: {
                        message: e.error_details["error"],
                        code: e.code,
                      },
                    }
                  end
  end

  def mapit
    return GdsApi.mapit unless Rails.env.development?

    GdsApi::Mapit.new("https://mapit.mysociety.org/")
  end
end
