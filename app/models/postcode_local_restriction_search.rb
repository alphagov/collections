class PostcodeLocalRestrictionSearch
  UK_POSTCODE_PATTERN = %r{
    \A
    # Outward code, for example SW1A
    (([A-Z][0-9]{1,2})|(([A-Z][A-HJ-Y][0-9]{1,2})|(([A-Z][0-9][A-Z])|([A-Z][A-HJ-Y][0-9][A-Z]?))))
    \s?
    [0-9][A-Z]{2} # Inward code, for example 2AA
    \Z
  }xi.freeze

  attr_reader :postcode
  delegate :no_information?, to: :location_lookup

  def initialize(postcode)
    @postcode = postcode
  end

  def sanitised_postcode
    # Use the uk_postcode gem to potentially transpose O/0 and I/1.
    @sanitised_postcode ||= UKPostcode.parse(
      postcode.gsub(/[^a-z0-9 ]/i, "").strip,
    ).to_s
  end

  def error_code
    return "postcodeLeftBlank" if postcode.empty?
    return "postcodeLeftBlankSanitized" if sanitised_postcode.empty?
    return "invalidPostcodeFormat" unless sanitised_postcode.match?(UK_POSTCODE_PATTERN)
    return "fullPostcodeNoMapitMatch" if location_lookup.postcode_not_found?
    return "fullPostcodeNoMapitValidation" if location_lookup.invalid_postcode?
  end

  def blank_postcode?
    %w[postcodeLeftBlank postcodeLeftBlankSanitized fullPostcodeNoMapitMatch].include?(error_code)
  end

  def invalid_postcode?
    %w[invalidPostcodeFormat fullPostcodeNoMapitValidation].include?(error_code)
  end

  def no_restriction?
    location_lookup.data.first&.england? && local_restriction.nil?
  end

  def location_lookup
    @location_lookup ||= LocationLookupService.new(sanitised_postcode)
  end

  def local_restriction
    return if error_code || location_lookup.no_information?

    @local_restriction ||= location_lookup.data
                                          .filter_map { |area| LocalRestriction.find(area.gss) }
                                          .first
  end
end
