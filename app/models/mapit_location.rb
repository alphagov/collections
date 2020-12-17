class MapitLocation
  attr_reader :area

  def initialize(area)
    @area = area
  end

  def gss
    area["codes"]["gss"]
  end

  def area_name
    area["name"]
  end

  def country
    area["country_name"]
  end

  def area_type
    area["type"]
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
