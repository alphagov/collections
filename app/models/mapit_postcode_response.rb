class MapitPostcodeResponse
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
