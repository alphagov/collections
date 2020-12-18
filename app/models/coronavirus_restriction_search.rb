class CoronavirusRestrictionSearch
  UK_POSTCODE_PATTERN = %r{
    \A
    # Outward code, for example SW1A
    (([A-Z][0-9]{1,2})|(([A-Z][A-HJ-Y][0-9]{1,2})|(([A-Z][0-9][A-Z])|([A-Z][A-HJ-Y][0-9][A-Z]?))))
    \s?
    [0-9][A-Z]{2} # Inward code, for example 2AA
    \Z
  }xi.freeze

  attr_reader :postcode, :error_code

  def initialize(postcode)
    @postcode = postcode
    @error_code = if postcode.empty?
                    "postcodeLeftBlank"
                  elsif sanitised_postcode.empty?
                    "postcodeLeftBlankSanitized"
                  elsif !sanitised_postcode.match(UK_POSTCODE_PATTERN)
                    "invalidPostcodeFormat"
                  end

    @locations = MapitLocation.locations_for_postcode(sanitised_postcode) unless @error_code
  rescue MapitLocation::LocationNotFound
    @error_code = "fullPostcodeNoMapitMatch"
  rescue MapitLocation::LocationInvalid
    @error_code = "fullPostcodeNoMapitValidation"
  end

  def blank_postcode?
    %w[postcodeLeftBlank postcodeLeftBlankSanitized fullPostcodeNoMapitMatch].include?(error_code)
  end

  def invalid_postcode?
    %w[invalidPostcodeFormat fullPostcodeNoMapitValidation].include?(error_code)
  end

  def devolved_nation?
    ["Northern Ireland", "Scotland", "Wales"].include?(locations&.first&.country)
  end

  def england_result
    return if error_code || locations.empty? || devolved_nation?

    @england_result ||= begin
      restriction_areas = locations.filter_map do |area|
        CoronavirusRestrictionArea.find(area.gss)
      end

      EnglandResult.new(sanitised_postcode, restriction_areas.first) if restriction_areas.any?
    end
  end

  def devolved_nation_result
    return if error_code || locations.empty? || !devolved_nation?

    @devolved_nation_result ||= DevolvedNationResult.new(sanitised_postcode, locations)
  end

private

  attr_reader :locations

  def sanitised_postcode
    # Use the uk_postcode gem to potentially transpose O/0 and I/1.
    @sanitised_postcode ||= UKPostcode.parse(
      postcode.gsub(/[^a-z0-9 ]/i, "").strip,
    ).to_s
  end

  class CoronavirusRestrictionSearch::EnglandResult
    attr_reader :postcode
    delegate :future_restriction, :current_restriction, to: :area

    def initialize(postcode, area)
      @postcode = postcode
      @area = area
    end

    def area_name
      area.name
    end

  private

    attr_reader :area
  end
end
