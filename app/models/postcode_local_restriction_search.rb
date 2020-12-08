class PostcodeLocalRestrictionSearch
  UK_POSTCODE_PATTERN = %r{
    \A
    ([Gg][Ii][Rr] 0[Aa]{2}) # Unusual postcodes
    |
    (
      # Outward code, for example SW1A
      (([A-Za-z][0-9]{1,2})|(([A-Za-z][A-Ha-hJ-Yj-y][0-9]{1,2})|(([A-Za-z][0-9][A-Za-z])|([A-Za-z][A-Ha-hJ-Yj-y][0-9][A-Za-z]?))))
      \s?
      [0-9][A-Za-z]{2} # Inward code, for example 2AA
    )
    \Z
  }x.freeze

  attr_reader :input
  delegate :no_information?, to: :location_lookup

  def initialize(input)
    @input = input
  end

  def postcode
    normalised_input unless error_code
  end

  def error_code
    return "postcodeLeftBlank" if input.empty?
    return "postcodeLeftBlankSanitized" if normalised_input.empty?
    return "invalidPostcodeFormat" unless normalised_input.match?(UK_POSTCODE_PATTERN)
    return "fullPostcodeNoMapitMatch" if location_lookup.postcode_not_found?
    return "fullPostcodeNoMapitValidation" if location_lookup.invalid_postcode?
  end

  def blank_postcode?
    %w[postcodeLeftBlank postcodeLeftBlankSanitized fullPostcodeNoMapitMatch].include?(error_code)
  end

  def invalid_postcode?
    %w[invalidPostcodeFormat fullPostcodeNoMapitValidation].include?(error_code)
  end

  def location_lookup
    @location_lookup ||= LocationLookupService.new(normalised_input)
  end

  def local_restriction
    return if location_lookup.no_information?

    @local_restriction ||= location_lookup.data
                                          .filter_map { |area| LocalRestriction.find(area.gss) }
                                          .first
  end

private

  def normalised_input
    # Use the uk_postcode gem to potentially transpose O/0 and I/1.
    @normalised_input ||= UKPostcode.parse(
      input.gsub(/[^a-z0-9 ]/i, "").strip,
    ).to_s
  end
end
