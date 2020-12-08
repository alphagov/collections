class PostcodeLocalRestrictionSearch
  UK_POSTCODE_PATTERN = %r{
    \A
    ([Gg][Ii][Rr] 0[Aa]{2}) # Unusual postcodes
    |
    (
      # Outward code
      (([A-Za-z][0-9]{1,2})|(([A-Za-z][A-Ha-hJ-Yj-y][0-9]{1,2})|(([A-Za-z][0-9][A-Za-z])|([A-Za-z][A-Ha-hJ-Yj-y][0-9][A-Za-z]?))))
      \s?
      [0-9][A-Za-z]{2} # Inward code
    )
    \Z
  }x

  attr_reader :query, :normalised_postcode
  delegate :no_information?, to: :location_lookup

  def initialize(query)
    @query = query
    # Use the uk_postcode gem to potentially transpose O/0 and I/1.
    @normalised_postcode = UKPostcode.parse(
      query.gsub(/[^a-z0-9 ]/i, "").strip
    ).to_s
  end

  def error_code
    return "postcodeLeftBlank" if query.empty?
    return "postcodeLeftBlankSanitized" if normalised_postcode.empty?
    return "invalidPostcodeFormat" unless normalised_postcode.match?(UK_POSTCODE_PATTERN)
    return "fullPostcodeNoMapitMatch" if location_lookup.postcode_not_found?
    return "fullPostcodeNoMapitValidation" if location_lookup.invalid_postcode?
  end

  def empty?
    %w[postcodeLeftBlank postcodeLeftBlankSanitised fullPostcodeNoMapitMatch].include?(error_code)
  end

  def invalid?
    %w[invalidPostcodeFormat fullPostcodeNoMapitValidation].include?(error_code)
  end

  def location_lookup
    @location_lookup ||= LocationLookupService.new(normalised_postcode)
  end

  def local_restriction
    return if location_lookup.no_information?

    @local_restriction ||= location_lookup.data
                                          .filter_map { |area| LocalRestriction.find(area.gss) }
                                          .first
  end
end
