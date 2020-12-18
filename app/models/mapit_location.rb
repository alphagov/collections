class MapitLocation
  class LocationNotFound < RuntimeError; end
  class LocationInvalid < RuntimeError; end

  def self.locations_for_postcode(postcode)
    mapit = if Rails.env.development?
              GdsApi::Mapit.new("https://mapit.mysociety.org/")
            else
              GdsApi.mapit
            end

    areas = Rails.cache.fetch("mapit-location-#{postcode}", expires_in: 3.hours) do
      mapit.location_for_postcode(postcode).areas
    end
    areas.filter_map { |area| new(area) if area.codes["gss"] }
  rescue GdsApi::HTTPNotFound
    raise LocationNotFound
  rescue GdsApi::HTTPClientError => e
    e.code == 400 ? raise(LocationInvalid) : raise
  end

  delegate :name, :type, to: :area

  def initialize(area)
    @area = area
  end

  def gss
    area.codes["gss"]
  end

  def country
    area.country_name
  end

private

  attr_reader :area
end
