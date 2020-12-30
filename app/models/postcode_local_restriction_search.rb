class PostcodeLocalRestrictionSearch
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

    @location_lookup = LocationLookupService.new(sanitised_postcode) unless @error_code
    @error_code = "fullPostcodeNoMapitMatch" if @location_lookup&.postcode_not_found?
    @error_code = "fullPostcodeNoMapitValidation" if @location_lookup&.invalid_postcode?
  end

  def blank_postcode?
    %w[postcodeLeftBlank postcodeLeftBlankSanitized fullPostcodeNoMapitMatch].include?(error_code)
  end

  def invalid_postcode?
    %w[invalidPostcodeFormat fullPostcodeNoMapitValidation].include?(error_code)
  end

  def devolved_nation?
    first_location = location_lookup&.data&.first

    !first_location.england?
  end

  def england_result
    return if error_code || location_lookup.data.empty? || devolved_nation?

    @england_result ||= begin
      local_restrictions = location_lookup.data.filter_map do |area|
        LocalRestriction.find(area.gss)
      end

      EnglandResult.new(sanitised_postcode, local_restrictions.first) if local_restrictions.any?
    end
  end

  def devolved_nation_result
    return if error_code || location_lookup.data.empty? || !devolved_nation?

    @devolved_nation_result ||= DevolvedNationResult.new(sanitised_postcode, location_lookup)
  end

private

  attr_reader :location_lookup

  def sanitised_postcode
    # Use the uk_postcode gem to potentially transpose O/0 and I/1.
    @sanitised_postcode ||= UKPostcode.parse(
      postcode.gsub(/[^a-z0-9 ]/i, "").strip,
    ).to_s
  end

  class EnglandResult
    attr_reader :postcode
    delegate :area_name,
             :current_alert_level,
             :future_alert_level,
             :future_start_time,
             to: :local_restriction

    def initialize(postcode, local_restriction)
      @postcode = postcode
      @local_restriction = local_restriction
    end

    def future_restriction?
      future_alert_level.present?
    end

  private

    attr_reader :local_restriction
  end

  class DevolvedNationResult
    attr_reader :postcode

    delegate :country,
             :northern_ireland?,
             :scotland?,
             :wales?,
             to: :first_location

    def initialize(postcode, location_lookup)
      @postcode = postcode
      @location_lookup = location_lookup
    end

    def area_name
      location_lookup.lower_tier_area_name
    end

  private

    attr_reader :location_lookup

    def first_location
      location_lookup.data.first
    end
  end
end
