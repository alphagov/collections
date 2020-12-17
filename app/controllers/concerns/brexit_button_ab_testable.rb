module BrexitButtonAbTestable
  CUSTOM_DIMENSION = 44
  TEST_NAME = "BrexitChecker".freeze

  def brexit_button_variant
    @brexit_button_variant ||= begin
      ab_test = GovukAbTesting::AbTest.new(
        TEST_NAME,
        dimension: CUSTOM_DIMENSION,
        allowed_variants: %w[A B Z],
        control_variant: "Z",
      )
      ab_test.requested_variant(request.headers)
    end
  end

  def show_brexit_button_variant?
    is_english_transition_page? && brexit_button_variant.variant?("B")
  end

  def is_english_transition_page?
    request.path == "/transition"
  end

  def set_brexit_button_variant
    brexit_button_variant.configure_response(response) if is_english_transition_page?
  end
end
