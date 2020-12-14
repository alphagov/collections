class MapitLocation
  class LocationNotFound < RuntimeError; end
  class LocationInvalid < RuntimeError; end

  def self.by_postcode(postcode)
    mapit = if Rails.env.development?
              GdsApi::Mapit.new("https://mapit.mysociety.org/")
            else
              GdsApi.mapit
            end

    response = mapit.location_for_postcode(postcode)
    response.areas.filter_map { |area| new(area) if area.codes["gss"] }
  rescue GdsApi::HTTPNotFound
    raise LocationNotFound
  rescue GdsApi::HTTPClientError => e
    e.code == 400 ? raise(LocationInvalid) : raise
  end

  def initialize(area)
    @area = area
  end

  def gss
    area.codes["gss"]
  end

  def area_name
    area.name
  end

  def country
    area.country_name
  end

  def area_type
    area.type
  end

private

  attr_reader :area
end
