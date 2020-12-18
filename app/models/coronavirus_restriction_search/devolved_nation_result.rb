class CoronavirusRestrictionSearch::DevolvedNationResult
  AREA_TYPES_FOR_NAME = %w[COI LBO LGD MTD UTA DIS].freeze

  attr_reader :postcode

  def initialize(postcode, locations)
    @postcode = postcode
    @locations = locations
  end

  def area_name
    locations.select { |l| l.type.in?(AREA_TYPES_FOR_NAME) }
             .first
             &.name
  end

  def country
    locations.first.country
  end

  def northern_ireland?
    country == "Northern Ireland"
  end

  def scotland?
    country == "Scotland"
  end

  def wales?
    country == "Wales"
  end

private

  attr_reader :locations
end
