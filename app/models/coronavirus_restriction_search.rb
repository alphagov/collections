class CoronavirusRestrictionSearch
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

    @locations = MapitLocation.by_postcode(sanitised_postcode) unless @error_code
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

  def result
    return if error_code || locations.empty?

    Result.new(sanitised_postcode, locations)
  end

private

  attr_reader :locations

  def sanitised_postcode
    # Use the uk_postcode gem to potentially transpose O/0 and I/1.
    @sanitised_postcode ||= UKPostcode.parse(
      postcode.gsub(/[^a-z0-9 ]/i, "").strip,
    ).to_s
  end
end
