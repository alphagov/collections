class CoronavirusRestrictionSearch::Result
  LOWER_TIER_AREA_CODES = %w[COI LBO LGD MTD UTA DIS].freeze

  attr_reader :postcode

  def initialize(postcode, locations)
    @postcode = postcode
    @locations = locations
    @area = locations.filter_map { |area| CoronavirusRestrictionArea.find(area.gss) }
                     .first
  end

  def current_restriction
    area&.current
  end

  def future_restriction
    area&.future
  end

  def area_name
    return area.name if area

    lower_tier = locations.select { |l| l.area_type.in?(LOWER_TIER_AREA_CODES) }
    lower_tier.first&.area_name
  end

  def tier_two?
    current_restriction&.alert_level == 2
  end

  def tier_three?
    current_restriction&.alert_level == 3
  end

  def country
    locations.first.country
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

  def devolved_nation?
    scotland? || wales? || northern_ireland?
  end

private

  attr_reader :locations, :area
end
