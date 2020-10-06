class LocationLookupService
  attr_reader :postcode

  def initialize(postcode)
    @postcode = postcode
  end

  def data
    location_data = areas.map do |_, area|
      next if area["codes"]["gss"].blank?

      {
        gss: area["codes"]["gss"],
        area_name: area["name"],
        country: area["country_name"],
      }
    end

    location_data.compact
  end

private

  def areas
    response["response"].select { |data| data.first == "areas" }.first.last
  end

  def response
    JSON.parse(GdsApi.mapit.location_for_postcode(postcode).to_json)
  end
end
