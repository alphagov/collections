class MapitLocation
  class LocationNotFound < RuntimeError; end
  class LocationInvalid < RuntimeError; end

  def self.by_postcode(postcode)
    mapit = if Rails.env.development?
              GdsApi::Mapit.new("https://mapit.mysociety.org/")
            else
              GdsApi.mapit
            end

    response = JSON.parse(mapit.location_for_postcode(postcode).to_json)
    response["response"].to_h["areas"].map { |_, area| self.new(area) }
  rescue GdsApi::HTTPNotFound
    raise LocationNotFound
  rescue GdsApi::HTTPClientError => e
    e.code == 400 ? raise(LocationInvalid) : raise
  end

  attr_reader :location

  def initialize(location)
    @location = location
  end

  def gss
    location["codes"]["gss"]
  end

  def area_name
    location["name"]
  end

  def country
    location["country_name"]
  end

  def area_type
    location["type"]
  end

  def england?
    country == "England"
  end

  def scotland?
    country == "Scotland"
  end

  def wales?
    country == "Wales"
  end

  def northern_ireland?
    country == "Northern Ireland"
  end
end
