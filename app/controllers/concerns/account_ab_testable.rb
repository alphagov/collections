module AccountAbTestable
  ACCOUNT_AB_CUSTOM_DIMENSION = 42
  ACCOUNT_AB_TEST_NAME = "AccountExperiment".freeze

  def account_variant
    @account_variant ||= begin
      ab_test = GovukAbTesting::AbTest.new(
        ACCOUNT_AB_TEST_NAME,
        dimension: ACCOUNT_AB_CUSTOM_DIMENSION,
        allowed_variants: %w[LoggedIn LoggedOut],
        control_variant: "LoggedOut",
      )
      ab_test.requested_variant(request.headers)
    end
  end

  def show_signed_in_header?
    account_variant.variant?("LoggedIn")
  end

  def show_signed_out_header?
    account_variant.variant?("LoggedOut")
  end
end
