module AbTests::LevelTwoBrowseAbTestable
  CUSTOM_DIMENSION = 47

  ALLOWED_VARIANTS = %(A B C).freeze

  def level_two_browse_test
    @level_two_browse_test ||= GovukAbTesting::AbTest.new(
      "LevelTwoBrowse",
      dimension: CUSTOM_DIMENSION,
      allowed_variants: ALLOWED_VARIANTS,
      control_variant: "Z",
    )
  end

  def level_two_browse_variant
    level_two_browse_test.requested_variant(request.headers)
  end

  def set_level_two_browse_response_header
    level_two_browse_variant.configure_response(response)
  end

  def level_two_browse_variant_b?
    page_under_test? && level_two_browse_variant.variant?("B")
  end

  def page_under_test?
    request.path =~ /browse\/[\w-]*\/[\w-]*/
  end
end
