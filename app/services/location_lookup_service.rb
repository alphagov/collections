class LocationLookupService
  attr_reader :postcode

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

  def error
    response[:error]
  end

private

  def areas
    return [] if response.blank?

    response["response"].select { |data| data.first == "areas" }.first.last
  end

  def response
    @response ||= begin
                    JSON.parse(GdsApi.mapit.location_for_postcode(postcode).to_json)
                  rescue GdsApi::HTTPNotFound, GdsApi::HTTPClientError => e
                    { error: e.error_details["error"] }
                  end
  end
end
