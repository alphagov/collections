class PostcodeService
  attr_reader :postcode

  def initialize(postcode)
    @postcode = postcode
  end

  def valid?
    postcode =~ /^([Gg][Ii][Rr] 0[Aa]{2})|((([A-Za-z][0-9]{1,2})|(([A-Za-z][A-Ha-hJ-Yj-y][0-9]{1,2})|(([A-Za-z][0-9][A-Za-z])|([A-Za-z][A-Ha-hJ-Yj-y][0-9][A-Za-z]?))))\s?[0-9][A-Za-z]{2})$/
  end

  def sanitize
    if postcode.present?
      # Strip trailing whitespace, non-alphanumerics, and use the
      # uk_postcode gem to potentially transpose O/0 and I/1.
      UKPostcode.parse(postcode.gsub(/[^a-z0-9 ]/i, "").strip).to_s
    end
  end
end
