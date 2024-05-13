module NewBrowseAbTestable
  # placeholder custom dimension
  CUSTOM_DIMENSION = 67

  ALLOWED_VARIANTS = %w[A B Z].freeze

  def new_browse_test
    @new_browse_test ||= GovukAbTesting::AbTest.new(
      "NewBrowse",
      dimension: CUSTOM_DIMENSION,
      allowed_variants: ALLOWED_VARIANTS,
      control_variant: "Z",
    )
  end

  def new_browse_variant
    new_browse_test.requested_variant(request.headers)
  end

  def set_new_browse_response_header
    new_browse_variant.configure_response(response)
  end

  def new_browse_variant_b?
    new_browse_page_under_test? && new_browse_variant.variant?("B")
  end

  def new_browse_page_under_test?
    request.path.starts_with?("/browse")
  end
end
